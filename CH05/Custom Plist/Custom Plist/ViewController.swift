//
//  ViewController.swift
//  Custom Plist
//
//  Created by 김나희 on 10/10/22.
//

import UIKit

class ViewController: UITableViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var married: UISwitch!
    
    var defaultPlist : NSDictionary!
    var accountlist = [String]()
    
    override func viewDidLoad() {
        if let path = Bundle.main.path(forResource: "UserInfo", ofType: "plist") {
            self.defaultPlist = NSDictionary(contentsOfFile: path)
        }
        
        // picker
        let picker = UIPickerView()
        picker.delegate = self
        self.accountTextField.inputView = picker // accountTextField의 입력 -> pickerView를 통해서
        
        // toolbar
        let toolbar = UIToolbar()
        // toolbar는 height만 설정해주면 된다. -> accessory view 영역에 표시되기 때문 (accessory view는 시스템에 의해 동적으로 좌표 결정)
        toolbar.frame = CGRect(x:0, y:0, width:0, height:35)
        toolbar.barTintColor = .lightGray
        self.accountTextField.inputAccessoryView = toolbar
        
        // toolbar 버튼들
        let done = UIBarButtonItem()
        done.title = "done"
        done.action = #selector(pickerDone)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let new = UIBarButtonItem()
        new.title = "new"
        new.target = self
        new.action = #selector(newAccount(_:))
        
        toolbar.setItems([new, flexSpace, done], animated: true)
        
        // 기본 저장소 객체에서 값 가져와서 적용
        let plist = UserDefaults.standard
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        
        // 처음 실행은 nil 반환하기 때문에 [String]()으로 옵셔널 체이닝
        let accountlist = plist.array(forKey:"accountlist") as? [String] ?? [String]()
        self.accountlist = accountlist
        
        if let account = plist.string(forKey:"selectedAccount") {
            self.accountTextField.text = account
            
            // custom plist에서 데이터 가져와서 적용
            let customPlist = "\(account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask,
                                                            true)
            let path = paths.first! as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
        
        if (self.accountTextField.text?.isEmpty)! {
            self.accountTextField.placeholder = "등록된 계정이 없습니다."
            self.gender.isEnabled = false
            self.married.isEnabled = false
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(newAccount(_:)))
        self.navigationItem.rightBarButtonItems = [addButton]
    }
    
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex

        // customPlist에 저장
        let customPlist = "\(self.accountTextField.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths.first! as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile:plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
        
        data.setValue(value, forKey: "gender")
        data.write(toFile: plist, atomically: true)
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        
        let customPlist = "\(self.accountTextField.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile:plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
        
        data.setValue(value, forKey: "married")
        data.write(toFile: plist, atomically: true)
    }
    
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1 // 선택할 컴포넌트 개수
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.accountlist.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.accountlist[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let account = self.accountlist[row]
        self.accountTextField.text = account // 선택된 계정 값으로 accountTextField 변경
                
        let plist = UserDefaults.standard
        plist.set(account, forKey: "selectedAccount")
        plist.synchronize()
    }
    
    @objc func newAccount(_ sender: Any) {
        self.view.endEditing(true)
    
        // alert
        let alert = UIAlertController(title: "새 계정을 입력하세요",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField() {
            $0.placeholder = "ex)abc@gmail.com"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if let account = alert.textFields?.first!.text {
                self.accountlist.append(account)
                self.accountTextField.text = account
                
                // 초기화
                self.name.text = ""
                self.gender.selectedSegmentIndex = 0
                self.married.isOn = false
                
                // 계정 목록 저장
                let plist = UserDefaults.standard
                
                plist.set(self.accountlist, forKey: "accountlist")
                plist.set(account, forKey: "selectedAccount")
                plist.synchronize()
                
                self.gender.isEnabled = true
                self.married.isEnabled = true
            }
        })
        self.present(alert, animated: false, completion: nil)
    }
    
    @objc func pickerDone(_ sender: Any) {
        self.view.endEditing(true)
        
        // 선택된 계정 - 커스텀 프로퍼티 read
        if let _account = self.accountTextField.text {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths.first! as NSString
            let clist = path.strings(byAppendingPaths: ["\(_account).plist"]).first!
            let data = NSDictionary(contentsOfFile:clist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
    }
    
    
    
    // 2번째 cell select
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && !(self.accountTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: nil,
                                          message: "이름을 입력하세요",
                                          preferredStyle: .alert)
            alert.addTextField() {
                $0.text = self.name.text
            }

            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                let value = alert.textFields?.first!.text
                
                let customPlist = "\(self.accountTextField.text!).plist"
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths.first! as NSString
                let plist = path.strings(byAppendingPaths: [customPlist]).first!
                let data = NSMutableDictionary(contentsOfFile:plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
                
                data.setValue(value, forKey: "name")
                data.write(toFile:plist, atomically: true)
                
                self.name.text = value
            })
            self.present(alert, animated: false, completion: nil)
        }
    }
    
}

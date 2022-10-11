//
//  ViewController.swift
//  UserDefaults
//
//  Created by 김나희 on 10/10/22.
//

import UIKit

class ListViewController: UITableViewController {
    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var married: UISwitch!
    
    @IBAction func edit(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
        
        alert.addTextField() {
            $0.text = self.name.text
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            let value = alert.textFields?[0].text
            let plist = UserDefaults.standard
            plist.setValue(value, forKey: "name")
            plist.synchronize()
            self.name.text = value
        })
        
        self.present(alert, animated: false, completion: nil)
    }
    
    @IBAction func changGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
        let plist = UserDefaults.standard
        plist.set(value, forKey: "genderIndex")
        plist.synchronize() // 동기화 처리
    }
    
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        let plist = UserDefaults.standard
        plist.set(value, forKey: "isMarried")
        plist.synchronize() // 동기화 처리
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plist = UserDefaults.standard
        self.name.text = plist.string(forKey: "name")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "genderIndex")
        self.married.isOn = plist.bool(forKey: "isMarried")
        
    }
    
    
}

//extension ListViewController {
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
//
//            alert.addTextField() {
//                $0.text = self.name.text
//            }
//
//            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
//                let value = alert.textFields?[0].text
//                let plist = UserDefaults.standard
//                plist.setValue(value, forKey: "name")
//                plist.synchronize()
//
//                self.name.text = value
//            })
//
//            self.present(alert, animated: false, completion: nil)
//        }
//    }
//}

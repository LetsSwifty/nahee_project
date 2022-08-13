//
//  RootViewController.swift
//  CH02
//
//  Created by 김나희 on 8/14/22.
//

import UIKit

final class RootViewController: UIViewController {

    var emailTextField: UITextField!
    var updateSwitch: UISwitch!
    var intervalStepper: UIStepper!
    var switchTextLabel: UILabel!
    var intervalTextLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "설정"
        
        let emailLabel = UILabel()
        emailLabel.frame = CGRect(x: 20, y: 100, width: 150, height: 30)
        emailLabel.text = "이메일"
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        
        emailTextField = UITextField()
        emailTextField.frame = CGRect(x: 120, y: 100, width: 220, height: 30)
        emailTextField.font = UIFont.systemFont(ofSize: 14)
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        
        let updateLabel = UILabel()
        updateLabel.frame = CGRect(x: 20, y: 150, width: 150, height: 30)
        updateLabel.text = "자동갱신"
        updateLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(updateLabel)
        
        updateSwitch = UISwitch()
        updateSwitch.frame = CGRect(x: 120, y: 150, width: 50, height: 30)
        updateSwitch.setOn(true, animated: true)
        updateSwitch.addTarget(self, action: #selector(presentUpdateValue(_:)), for: .valueChanged)

        
        let intervalLabel = UILabel()
        intervalLabel.frame = CGRect(x: 20, y: 200, width: 150, height: 30)
        intervalLabel.text = "갱신주기"
        intervalLabel.font = UIFont.systemFont(ofSize: 14)
        
        intervalStepper = UIStepper()
        intervalStepper.frame = CGRect(x: 120, y: 200, width: 50, height: 30)
        intervalStepper.minimumValue = 0
        intervalStepper.maximumValue = 100
        intervalStepper.stepValue = 1
        intervalStepper.value = 0
        intervalStepper.addTarget(self, action: #selector(presentIntervalValue(_:)), for: .valueChanged)
        
        switchTextLabel = UILabel()
        switchTextLabel.frame = CGRect(x: 250, y: 150, width: 100, height: 30)
        switchTextLabel.font = UIFont.systemFont(ofSize: 12)
        switchTextLabel.textColor = .red
        switchTextLabel.text = "갱신함"
        
        intervalTextLabel = UILabel()
        intervalTextLabel.frame = CGRect(x: 250, y: 200, width: 100, height: 30)
        intervalTextLabel.font = UIFont.systemFont(ofSize: 12)
        intervalTextLabel.textColor = .red
        intervalTextLabel.text = "0분마다"
        
        let submitButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(submit(_:)))
        self.navigationItem.rightBarButtonItem = submitButton
        
        view.addSubview(emailLabel)
        view.addSubview(updateLabel)
        view.addSubview(intervalLabel)
        view.addSubview(emailTextField)
        view.addSubview(updateSwitch)
        view.addSubview(intervalStepper)
        view.addSubview(switchTextLabel)
        view.addSubview(intervalTextLabel)

    }
    
    @objc func presentUpdateValue(_ sender: UISwitch) {
        switchTextLabel.text = sender.isOn ? "갱신함" : "갱신하지않음"
    }


    @objc func presentIntervalValue(_ sender: UIStepper) {
        intervalTextLabel.text = "\(Int(sender.value))분마다"
    }
    
    @objc func submit(_ sender: Any) {
        let vc = OutputViewController()
        vc.email = emailTextField.text
        vc.update = updateSwitch.isOn
        vc.interval = intervalStepper.value
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

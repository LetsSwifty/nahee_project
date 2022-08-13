//
//  OutputViewController.swift
//  CH02
//
//  Created by 김나희 on 8/14/22.
//

import UIKit

final class OutputViewController: UIViewController {
    var email: String?
    var update: Bool?
    var interval: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let emailLabel = UILabel(frame: CGRect(x: 50, y: 100, width: 300, height: 30))
        let updateLabel = UILabel(frame: CGRect(x: 50, y: 150, width: 300, height: 30))
        let intervalLabel = UILabel(frame: CGRect(x: 50, y: 200, width: 300, height: 30))
        
        if let email = email { emailLabel.text = "\(email)" }
        updateLabel.text = "\(update! ? "업데이트 함" : "업데이트 안함")"
        intervalLabel.text = "\(interval!)분마다"

        view.addSubview(emailLabel)
        view.addSubview(updateLabel)
        view.addSubview(intervalLabel)
    }
}

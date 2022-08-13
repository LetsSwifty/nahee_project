//
//  ViewController.swift
//  CH02
//
//  Created by 김나희 on 8/14/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 50, y: 100, width: 150, height: 300)
        button.center = CGPoint(x: view.frame.size.width / 2, y: 100)
        button.setTitle("테스트", for: .normal)
        button.addTarget(self, action: #selector(btnDidTap(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func btnDidTap(_ sender: Any) {
        if let btn = sender as? UIButton {
            btn.setTitle("클릭", for: .normal)
        }
    }

}


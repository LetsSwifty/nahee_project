//
//  ViewController.swift
//  APITest
//
//  Created by 김나희 on 10/16/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var responseView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func json(_ sender: Any) {
        let param = ["userId": userID.text!,
                     "name": name.text!]
        let data = try! JSONSerialization.data(withJSONObject: param, options: [])
        guard let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echoJSON") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(String(data.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error:", error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else {
                        return
                    }
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String
                    
                    if result == "SUCCESS" {
                        self.responseView.text = "아이디: \(userId!) + \n"
                        + "이름: \(name!) + \n"
                        + "응답결과: \(result!) + \n"
                        + "응답시간: \(timestamp!) + \n"
                        + "요청방식: x-www-form-urlencoded"
                    }
                } catch let error as NSError {
                    print("ERROR: ", error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func post(_ sender: Any) {
        let param = "userId=\(userID.text!)&name=\(name.text!)"
        let data = param.data(using: .utf8)
        guard let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echo") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        // header 설정
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(String(data!.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error:", error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else {
                        return
                    }
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String
                    
                    if result == "SUCCESS" {
                        self.responseView.text = "아이디: \(userId!) + \n"
                        + "이름: \(name!) + \n"
                        + "응답결과: \(result!) + \n"
                        + "응답시간: \(timestamp!) + \n"
                        + "요청방식: x-www-form-urlencoded"
                    }
                } catch let error as NSError {
                    print("ERROR: ", error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func callCurrentTime(_ sender: Any) {
        do {
            // GET 호출
            guard let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime") else {
                return
            }
            
            AF.request(url).responseString { response in
                if let error = response.error {
                    print(error.localizedDescription)
                }
                self.currentTime.text = response.value
                self.currentTime.sizeToFit()
            }
        }
        
    }
}


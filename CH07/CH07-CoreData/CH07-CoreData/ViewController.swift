//
//  ViewController.swift
//  CH07-CoreData
//
//  Created by 김나희 on 10/14/22.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    lazy var list: [NSManagedObject] = {
        return fetch()
    }()
        
    func fetch() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")
        // 정렬
        let sort = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let result = try! context.fetch(fetchRequest)
        
        return result
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }


}

extension ViewController {
    func save(title: String, contents: String) -> Bool {
        // 1. app delegate 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // 2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext
        // 3. 관리 객체 생성, 값 설정
        let object = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")
        
        // 로그 데이터
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        
        (object as! BoardMO).addToLogs(logObject) // 게시글 객체에 로그 객체 추가
        
        // 4. 영구저장소에 커밋
        do {
            try context.save()
            list.insert(object, at: 0) // 성공시 list property에 추가
            return true
        } catch {
            context.rollback() // 실패시 롤백
            return false
        }
    }
    
    func delete(object: NSManagedObject) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(object)
        
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    func edit(object: NSManagedObject, title: String, contents: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")
        
        // 로그
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        logObject.type = LogType.edit.rawValue
        print(LogType.edit.rawValue)
        (object as! BoardMO).addToLogs(logObject)
        
        do {
            try context.save()
            list = fetch() // list 갱신
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    @objc func add(_ sender: Any) {
        let alert = UIAlertController(title: "게시글 등록", message: nil, preferredStyle: .alert)
        alert.addTextField() { $0.placeholder = "제목" }
        alert.addTextField() { $0.placeholder = "내용" }
            
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "저장", style: .default) { _ in
            guard let title = alert.textFields?.first?.text,
                  let contents = alert.textFields?.last?.text else {
                      return
                  }
                    
            if self.save(title: title, contents: contents) {
                self.tableView.reloadData()
            }
        })

        present(alert, animated: false)

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = list[indexPath.row]
        let title = record.value(forKey: "title") as? String
        let contents = record.value(forKey: "contents") as? String
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = title
        cellContent.secondaryText = contents
        cell.contentConfiguration = cellContent
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let object = list[indexPath.row]
        if delete(object: object) {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = list[indexPath.row]
    
        let alert = UIAlertController(title: "게시글 수정", message: nil, preferredStyle: .alert)
        alert.addTextField() { $0.placeholder = "제목" }
        alert.addTextField() { $0.placeholder = "내용" }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "저장", style: .default) { _ in
            guard let title = alert.textFields?.first?.text,
                  let contents = alert.textFields?.last?.text else {
                      return
                  }
                    
            if self.edit(object: object, title: title, contents: contents) {
                guard let cell = tableView.cellForRow(at: indexPath) else { return }
                var cellContent = cell.defaultContentConfiguration()
                cellContent.text = title
                cellContent.secondaryText = contents
                cell.contentConfiguration = cellContent
                
                tableView.moveRow(at: indexPath, to: IndexPath(item: 0, section: 0))
            }
        })

        present(alert, animated: false)
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let object = list[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "LogVC") as! LogViewController
        vc.board = (object as! BoardMO)
        show(vc, sender: self)
    }
}

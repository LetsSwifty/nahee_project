//
//  LogViewController.swift
//  CH07-CoreData
//
//  Created by 김나희 on 10/15/22.
//

import UIKit

class LogViewController: UITableViewController {
    var board: BoardMO!
    
    lazy var list: [LogMO] = {
        return board.logs?.array as! [LogMO]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = board.title
    }
}

extension LogViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "logCell") else {
            return UITableViewCell()
        }
        
        let row = list[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = "\(String(describing: row.regdate))에 \(row.type.toLogType()) 되었습니다."
        content.textProperties.font = .systemFont(ofSize: 12)
        cell.contentConfiguration = content
        
        return cell
    }
}

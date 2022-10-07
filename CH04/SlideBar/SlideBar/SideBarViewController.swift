//
//  SideBarViewController.swift
//  SlideBar
//
//  Created by 김나희 on 10/6/22.
//

import UIKit

class SideBarViewController: UITableViewController {
    
    private lazy var accountLabel: UILabel = {
        let accountLabel = UILabel()
        accountLabel.frame = CGRect(x:10, y:30, width: self.view.frame.width, height: 30)
        accountLabel.text = "skgml@naver.com"
        accountLabel.textColor = UIColor.white
        accountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        return accountLabel
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x:0, y:0, width: self.view.frame.width, height:70)
        view.backgroundColor = UIColor.gray
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        tableView.addSubview(accountLabel)
        tableView.tableHeaderView = headerView
    }
    
}

extension SideBarViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "id") else {
            return UITableViewCell()
        }
        
        // cell.textLabel, detailTextLabel, imageView.. 등 iOS 14.0에서 deprecate !!
        // defaultContentConfiguration 이용
        
        var content = cell.defaultContentConfiguration()
        content.text = "메뉴 0\(indexPath.row+1)"
        content.textProperties.font = .systemFont(ofSize: 14)
        content.image = UIImage(named: "icon0\(indexPath.row+1)")
        
        cell.contentConfiguration = content
        
        return cell
    }
    
}

//
//  TableViewController.swift
//  ViewPagers_Example
//
//  Created by Steve on 28/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

class TableViewController: UIViewController {
    var tableView: UITableView!
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kidentifier)
        view.backgroundColor = UIColor.cyan
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.random
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: kidentifier, for: indexPath) else {
//            fatalError("error")
//        }
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: kidentifier, for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
}

extension TableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = TopViewController()
        dest.title = self.items[indexPath.row]
        self.navigationController?.pushViewController(dest, animated: true)
    }
}


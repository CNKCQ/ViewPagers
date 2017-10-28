//
//  PageTableController.swift
//  ViewPagers_Example
//
//  Created by Steve on 28/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

let kidentifier = "kidentifier"

class PageTableController: UIViewController {
    var tableView: UITableView!
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kidentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        items = [
            "1",
            "2",
            "1",
            "1",
            "1",
            "1",
            "1",
        ]
    }
    
    
}

extension PageTableController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ViewController(), animated: true)
    }
}

extension PageTableController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kidentifier, for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
}

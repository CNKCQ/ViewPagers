//
//  ViewController.swift
//  ViewPager
//
//  Created by wangchengqvan@gmail.com on 07/02/2017.
//  Copyright (c) 2017 wangchengqvan@gmail.com. All rights reserved.
//

import UIKit
import ViewPagers
import SnapKit

enum ViewPagerOptions: String {
    case push = "push"
    case present = "present"
}

class ViewController: UIViewController {
    
    var tableView: UITableView!
    var items: [String] = ["push", "present"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        title = "ViewPagers"
        edgesForExtendedLayout = []
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option: ViewPagerOptions = ViewPagerOptions(rawValue: self.items[indexPath.row]) ?? .push
        switch option {
        case .push:
            let dest = NavTabViewController()
            self.navigationController?.pushViewController(dest, animated: true)
        case .present:
            let dest = PreTabViewController()
            let navDest = UINavigationController(rootViewController: dest)
            self.present(navDest, animated: true, completion: nil)
        }
    }
}

struct CustomPagerBarStyle: StyleCustomizable {
    
    var titleBgColor: UIColor {
        return UIColor.brown
    }
    
    var isShowPageBar: Bool {
        return true
    }
    
    var isSplit: Bool {
        return true
    }
    
    var bottomLineW: CGFloat {
        return 30
    }
    
    var isAnimateWithProgress: Bool {
        return true
    }
    
    var bottomLineH: CGFloat {
        return 1
    }
    
    var titleMargin: CGFloat {
        return 10
    }
    
    var isShowBottomLine: Bool {
        return true
    }
}

struct PagerItem {
    
    var title: String
    var cls: UIViewController
    
    init(_ title: String, cls: UIViewController) {
        self.title = title
        self.cls = cls
    }
}





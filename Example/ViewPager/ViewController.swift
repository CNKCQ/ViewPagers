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


class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ViewPagers"
        edgesForExtendedLayout = []

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(removeItems))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItems))
    }
    
    @objc func removeItems() {
        let dest = NavTabViewController()
        self.navigationController?.pushViewController(dest, animated: true)
    }
    
    @objc func addItems() {
        let dest = PreTabViewController()
        let navDest = UINavigationController(rootViewController: dest)
        self.present(navDest, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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





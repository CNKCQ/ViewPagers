//
//  ViewController.swift
//  ViewPager
//
//  Created by wangchengqvan@gmail.com on 07/02/2017.
//  Copyright (c) 2017 wangchengqvan@gmail.com. All rights reserved.
//

import UIKit
import SnapKit
import ViewPagers

struct CustomPagerBarStyle: StyleCustomizable {
    
    var titleBgColor: UIColor {
        return UIColor.gray
    }
    
    var normalColor: UIColor {
        return UIColor.white.withAlphaComponent(0.6)
    }
    
    var selectedColor: UIColor {
        return UIColor.white
    }
    
    var isShowPageBar: Bool {
        return true
    }
    
    var bottomLineMargin: CGFloat {
        return 60
    }
    
    var bottomLineColor: UIColor {
        return UIColor.white
    }
    
}

class ViewController: UIViewController {
    var viewPagerController: ViewPagerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        print("🌹 44444")
        
        viewPagerController = ViewPagerController(viewPagers, pagerBar: CustomPagerBarStyle())
        viewPagerController.pageDidAppear = { (controller, index) in
            print(controller, index)
        }
        viewPagerController.didSelected = { (index) in
            print("didSelected-----\(index)")
        }
        addChildViewController(viewPagerController)
        view.addSubview(viewPagerController.view)
        viewPagerController.view.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp.top).offset(200)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let titles = ["待接单1", "代取件2", "配送中5", "已完成4", "待处理2"]
        viewPagerController.viewPageBar.update(titles)
    }
    
    lazy var viewPagers: [ViewPager] =  {
        let first = TabFController()
        let second = TabSController()
        let third = TabTController()
        let fouth = TabSController()
        let fieve = TabTController()
        let titles = ["待接单", "代取件", "配送中", "已完成", "待处理"]
        first.tabBarItem.title = titles[0]
        second.tabBarItem.title = titles[1]
        third.tabBarItem.title = titles[2]
        fouth.tabBarItem.title = titles[3]
        fieve.tabBarItem.title = titles[4]
        let viewPs: [(UIViewController, String)] = [(first, titles[0]), (second, titles[1]), (third, titles[2]), (fouth, titles[3]), (fieve, titles[4])]
        let viewPagers = viewPs.flatMap(
        {
            ViewPager(title: $1, controller: $0)
            
            }
        )
        return viewPagers
    }()
}


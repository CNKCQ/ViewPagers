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

struct CustomPagerBarStyle: StyleCustomizable {
    
    var titleBgColor: UIColor {
        return UIColor.white
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
        return false
    }
    
    var bottomLineH: CGFloat {
        return 1
    }
    
    var titleMargin: CGFloat {
        return 0
    }
    
}

class ViewController: UIViewController {
    
    var viewPagerController: ViewPagerController!
    var titles: [String] = [] {
        didSet {
            if titles.count < 2 {
                self.viewPagerController.isViewPageBarHidden = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 2.创建主题内容
        let style = CustomPagerBarStyle()
        var titles: [String] =
            ["待接单", "代取件了吗", "配送中", "已完成", "待处理"]
//        ["待接单", "代取件"]
//        titles.removeAll()
//        for index in 0..<15 {
//            titles.append("Tab \(index)")
//        }
        var childVcs = [UIViewController]()
        
        for title in titles {
            let anchorVc = PageViewController()
            anchorVc.titleLabel.text = title
            childVcs.append(anchorVc)
        }
        edgesForExtendedLayout = []
        viewPagerController = ViewPagerController(frame: .zero, titles: titles, style: style, childVcs: childVcs)
        addChildViewController(viewPagerController)
        view.addSubview(viewPagerController.view)
        viewPagerController.didselected = { (viewPageBar, index) in
            print("🌹", viewPageBar, index, "🌹")
        }
        viewPagerController.pageViewDidAppear = { (viewController, index) in
            print("🌹", viewController, index, "🌹")
        }
        viewPagerController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
//        delay(after: 5) {
//            self.titles = ["hello"]
//        }
    }
    
    func delay(after: TimeInterval, execute: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + after
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            execute()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


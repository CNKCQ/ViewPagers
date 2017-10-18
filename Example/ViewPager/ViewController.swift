//
//  ViewController.swift
//  ViewPager
//
//  Created by wangchengqvan@gmail.com on 07/02/2017.
//  Copyright (c) 2017 wangchengqvan@gmail.com. All rights reserved.
//

import UIKit
import ViewPager
import SnapKit

struct CustomPagerBarStyle: StyleCustomizable {
    
    var titleBgColor: UIColor {
        return UIColor.white
    }
    
    var isShowPageBar: Bool {
        return true
    }
    
    var isSplit: Bool {
        return false
    }
    
    var bottomLineW: CGFloat {
        return 30
    }
    
    var isAnimateWithProgress: Bool {
        return false
    }
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 2.创建主题内容
        let style = CustomPagerBarStyle()
        let titles =
//            ["待接单", "代取件了吗", "配送中", "已完成", "待处理"]
        ["待接单", "代取件了吗", "配送中", "已完成", "待处理", "代取件了吗", "配送中", "已完成", "待处理", "代取件了吗", "配送中", "已完成", "待处理", "代取件了吗", "配送中", "已完成", "待处理"]
        var childVcs = [UIViewController]()
        for title in titles {
            let anchorVc = PageViewController()
            anchorVc.titleLabel.text = title
            childVcs.append(anchorVc)
        }
        edgesForExtendedLayout = []
        let viewPagerController = ViewPagerController(frame: .zero, titles: titles, style: style, childVcs: childVcs)
        addChildViewController(viewPagerController)
        view.addSubview(viewPagerController.view)
        viewPagerController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


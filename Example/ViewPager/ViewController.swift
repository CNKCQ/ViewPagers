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

class ViewController: UIViewController {
    var pageView: PageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 2.创建主题内容
        let style = TitleStyle(isShowBottomLine: true, bottomLineColor: .orange, bottomLineH: 5)
        let titles = ["待接单", "代取件", "配送中", "已完成", "待处理"]
        var childVcs = [UIViewController]()
        for title in titles {
            let anchorVc = PageViewController()
            anchorVc.title = title
            anchorVc.titleLabel.text = title
            childVcs.append(anchorVc)
        }
        edgesForExtendedLayout = []
        pageView = PageView(frame: .zero, titles: titles, style: style, childVcs: childVcs, parentVc: self,didSelected: { (index) in
            print("🌹", "selected", index, "🌹")
        }, viewDidAppear: { (page, index) in
            print("🌹", page?.title ?? "", "appear", index, "🌹")
        })
   
        view.addSubview(pageView)
        pageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageView.viewDidLayoutSubviews() // 横竖屏适配
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


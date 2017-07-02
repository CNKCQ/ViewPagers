//
//  ViewController.swift
//  ViewPager
//
//  Created by wangchengqvan@gmail.com on 07/02/2017.
//  Copyright (c) 2017 wangchengqvan@gmail.com. All rights reserved.
//

import UIKit
import ViewPager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 2.创建主题内容
        let style = TitleStyle(isShowBottomLine: true, bottomLineColor: .orange, bottomLineH: 5)
        let pageFrame = CGRect(x: 0, y: 44 + 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 44 - 20)
        let titles = ["1", "2", "3"]
        var childVcs = [UIViewController]()
        for _ in titles {
            let anchorVc = PageViewController()
            childVcs.append(anchorVc)
        }
        let pageView = PageView(frame: pageFrame, titles: titles, style: style, childVcs: childVcs, parentVc: self)
        view.addSubview(pageView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


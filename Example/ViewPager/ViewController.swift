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
    
    var viewPagerController: ViewPagerController!
    var pagerItems: [PagerItem] = [] {
        didSet {
            if pagerItems.count < 2 {
                self.viewPagerController?.isViewPageBarHidden = true
            }
            self.viewPagerController?.pageItems = pagerItems
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        pagerItems = [
            PagerItem("待接单", cls: PageViewController()),
            PagerItem("已接单", cls: PageViewController()),
            PagerItem("代发货", cls: PageViewController()),
            PagerItem("已发货", cls: PageViewController()),
            PagerItem("已完成", cls: PageViewController()),
        ]
        viewPagerController = ViewPagerController(frame: .zero, style: CustomPagerBarStyle())
        viewPagerController.pageItems = pagerItems
        viewPagerController.dataSource = self
        viewPagerController.delegate = self
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeItems))
    }
    
    @objc func changeItems() {
        self.pagerItems.removeLast()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: ViewPagerDataSource {
    
    func itemsOfViewPager() -> [PagerItem] {
        return self.pagerItems
    }
}

extension ViewController: ViewPagerDelegate {
    
    func styleOfBarItem() -> StyleCustomizable {
        return CustomPagerBarStyle()
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
        return false
    }
    
    var bottomLineH: CGFloat {
        return 1
    }
    
    var titleMargin: CGFloat {
        return 0
    }
    
    var isShowBottomLine: Bool {
        return true
    }
}





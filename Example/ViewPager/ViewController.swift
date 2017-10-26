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
    
    var viewPager: ViewPager!
    var pagerItems: [PagerItem] = [] {
        didSet {
            if pagerItems.count < 2 {
                self.viewPager?.isViewPagerBarHidden = true
            }
            self.viewPager?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        pagerItems = [
            PagerItem("待接单1", cls: PageViewController()),
            PagerItem("已接单2", cls: PageViewController()),
            PagerItem("代发货3", cls: PageViewController()),
            PagerItem("已发货4", cls: PageViewController()),
            PagerItem("已完成5", cls: PageViewController()),
            PagerItem("待接单6", cls: PageViewController()),
            PagerItem("已接单7", cls: PageViewController()),
            PagerItem("代发货8", cls: PageViewController()),
            PagerItem("已发货9", cls: PageViewController()),
            PagerItem("已完成10", cls: PageViewController()),
            PagerItem("待接单11", cls: PageViewController()),
            PagerItem("已接单12", cls: PageViewController()),
            PagerItem("代发货13", cls: PageViewController()),
            PagerItem("已发货14", cls: PageViewController()),
            PagerItem("已完成15", cls: PageViewController()),
//            "待接单",
//            "已接单",
//            "代发货",
//            "已发货",
//            "已完成",
        ]
        self.viewPager = ViewPager(CustomPagerBarStyle())
        self.viewPager.delegate = self
        self.viewPager.dataSource = self
        self.view.addSubview(self.viewPager)
        self.viewPager.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
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
    
    func titlesOfViewPager() -> [String] {
        return self.pagerItems.flatMap({ $0.title })
    }
    
    func viewPager(_ cell: UICollectionViewCell, index: Int) -> UICollectionViewCell {
        let controller = pagerItems.flatMap({ $0.cls })[index]
        addChildViewController(controller)
        cell.contentView.addSubview(controller.view)
        controller.view.snp.makeConstraints { (make) in
            make.edges.equalTo(cell.contentView)
        }
        return cell
    }
}


extension ViewController: ViewPagerDelegate {
    
    func viewPager(_ viewPager: ViewPager, didSelected index: Int) {
        print("🌹---\(index)----selected")
    }
    
    func viewPager(_ viewPager: ViewPager, willAppear cell: UICollectionViewCell, at index: Int) {
        print("🌹---\(index)---willDisPlay")
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
        return false
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





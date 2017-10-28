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


class PreTabViewController: UIViewController {
    
    var viewPager: ViewPager!
    var pagerItems: [PagerItem] = [] {
        didSet {
            if pagerItems.count < 2 {
                self.viewPager?.isViewPagerBarHidden = true
            } else {
                self.viewPager?.isViewPagerBarHidden = false
            }
            self.viewPager?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ViewPagers"
        edgesForExtendedLayout = []
        pagerItems = [
            PagerItem("待接单1", cls: Next1ViewController()),
            PagerItem("已接单2", cls: Next2ViewController()),
            //            PagerItem("代发货3", cls: PageTableController()),
            //            PagerItem("已发货4", cls: PageViewController()),
            //            PagerItem("已完成5", cls: PageTableController()),
            //            PagerItem("待接单6", cls: PageViewController()),
            //            PagerItem("已接单7", cls: PageTableController()),
            //            PagerItem("代发货8", cls: PageViewController()),
            //            PagerItem("已发货9", cls: PageTableController()),
            //            PagerItem("已完成10", cls: PageViewController()),
            //            PagerItem("待接单11", cls: PageViewController()),
            //            PagerItem("已接单12", cls: PageViewController()),
            //            PagerItem("代发货13", cls: PageViewController()),
            //            PagerItem("已发货14", cls: PageTableController()),
            //            PagerItem("已完成15", cls: PageViewController()),
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
    
    //    func delay(after: TimeInterval, execute: @escaping () -> Void) {
    //        let delayTime = DispatchTime.now() + after
    //        DispatchQueue.main.asyncAfter(deadline: delayTime) {
    //            execute()
    //        }
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let trashItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeItems))
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItems))
        self.navigationItem.rightBarButtonItems = [trashItem, addItem]
    }
    
    @objc func removeItems() {
        self.pagerItems.removeLast()
    }
    
    @objc func addItems() {
        let newItem1 = PagerItem("Tab 1", cls: Next1ViewController())
        let newItem2 = PagerItem("Tab 2", cls: Next2ViewController())
        self.pagerItems.append(newItem1)
        self.pagerItems.append(newItem2)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension PreTabViewController: ViewPagerDataSource {
    
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


extension PreTabViewController: ViewPagerDelegate {
    
    func viewPager(_ viewPager: ViewPager, didSelected index: Int) {
        print("🌹---\(index)----selected")
    }
    
    func viewPager(_ viewPager: ViewPager, willAppear cell: UICollectionViewCell, at index: Int) {
        print("🌹---\(index)---willDisPlay")
    }
    
}







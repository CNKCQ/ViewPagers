//
//  ViewPagerController.swift
//  Elegant
//
//  Created by Steve on 29/09/2017.
//  Copyright © 2017 KingCQ. All rights reserved.
//

import UIKit

public class ViewPagerController: UIViewController {
    public var viewPageBar: ViewPageBar!
    var pagerTabController: PagerTabController!
    private var style: StyleCustomizable!
    private var viewPagers: [ViewPager] = []
    public var pageDidAppear: ((_ toPage: UIViewController, _ index: Int) -> Void)?
    public var didSelected: ((_ index: Int) -> Void)?
    public var selectedIndex: Int? {
        didSet {
            self.pagerTabController.viewPageBar(viewPageBar, selectedIndex: selectedIndex ?? 0)
        }
    }
    
    
    public init(_ pagers: [ViewPager]? = [], pagerBar style: StyleCustomizable? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.viewPagers = pagers ?? []
        self.style = style ?? DefaultPagerStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        pagerTabController = PagerTabController(viewPagers.flatMap({$0.controller}))
        pagerTabController.pageDidAppear = self.pageDidAppear
        pagerTabController.didSelected = self.didSelected
        pagerTabController.tabBar.isHidden = style.isShowPageBar
        addChildViewController(pagerTabController)
        view.addSubview(pagerTabController.view)
        let titleH : CGFloat = style.titleHeight
        viewPageBar = ViewPageBar(frame: .zero, titles: viewPagers.flatMap({$0.title}), style : style)
        viewPageBar.delegate = pagerTabController
        view.addSubview(viewPageBar)
        viewPageBar.snp.makeConstraints { (make) in
            make.right.left.equalTo(self.view)
            make.height.equalTo(style.isShowPageBar ? titleH : 0)
            make.top.equalTo(self.view.snp.top)
        }
        pagerTabController.view.snp.makeConstraints { (make) in
            make.left.right.equalTo(viewPageBar)
            make.top.equalTo(self.viewPageBar.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
}

//
//  ViewPagerController.swift
//  Elegant
//
//  Created by Steve on 29/09/2017.
//  Copyright © 2017 KingCQ. All rights reserved.
//

import UIKit

public protocol ViewPagerDelegate: class {
    
    func styleOfBarItem() -> StyleCustomizable
    
}

public protocol ViewPagerDataSource: class {
    
    func itemsOfViewPager() -> [PagerItem]
    
}

public class ViewPagerController: UIViewController {
    
    public var style : StyleCustomizable?
    
    public weak var dataSource: ViewPagerDataSource?
    
    public weak var delegate: ViewPagerDelegate?
    
    public var viewPageBar : ViewPageBar!
    
    fileprivate var contentView : PageContentView!
    
    public var pageItems: [PagerItem] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    public var titles : [String] = [] {
        didSet {
            self.viewPageBar?.titles = titles
        }
    }
    
    public var childVcs : [UIViewController] = [] {
        didSet {
            self.contentView.childViewControllers = childVcs
        }
    }

    public var didselected: ((_ viewPageBar: ViewPageBar, _ index: Int) -> Void)?
    
    public var pageViewDidAppear: ((_ viewController: UIViewController, _ index: Int) -> Void)?
    
    public var isViewPageBarHidden: Bool = false {
        didSet {
            let height: CGFloat = isViewPageBarHidden ? 0 : self.viewPageBar.style.titleHeight
            self.viewPageBar.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            self.viewPageBar.superview?.layoutIfNeeded()
        }
    }

    public convenience init(frame: CGRect, style: StyleCustomizable? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.style = style
        setupContentView()
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentView.viewWillLayoutSubviews()
        viewPageBar.viewWillLayoutSubviews()
        contentView.setCurrentIndex(viewPageBar.currentIndex)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewPageBar.viewDidLayoutSubviews()
    }
        
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewPageBar.style.isShowBottomLine == true {
            self.viewPageBar.delay(after: 0.2, execute: { [weak self] in
                self?.viewPageBar.setupBottomLine()
            })
        }
        reloadData()
    }
    
    func reloadData() {
        self.titles = self.pageItems.flatMap({ $0.title})
        self.childVcs = self.pageItems.flatMap({$0.class})
        self.viewPageBar.collectionView.reloadData()
        self.contentView.collectionView.reloadData()
    }
}


extension ViewPagerController {
    
    fileprivate func setupContentView() {
        guard let style = self.style else {
            return
        }
        let titleH : CGFloat = style.titleHeight
        titles = self.dataSource?.itemsOfViewPager().flatMap({ $0.title }) ??  []
        viewPageBar = ViewPageBar(frame: .zero, titles: titles, style : style)
        viewPageBar.delegate = self
        view.addSubview(viewPageBar)
        viewPageBar.snp.makeConstraints { (make) in
            make.right.left.equalTo(self.view)
            make.height.equalTo(titleH)
            make.top.equalTo(self.view.snp.top)
        }
        contentView = PageContentView(frame: .zero, childViewControllers: childVcs, parentViewController: self)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.viewPageBar.snp.bottom)
        }
    }
}

// MARK: - ContentViewDelegate
extension ViewPagerController : ContentViewDelegate {
    
    func contentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        viewPageBar.updateProgress(progress, fromIndex: sourceIndex, toIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: PageContentView) {
        self.pageViewDidAppear?(self.childVcs[self.viewPageBar.currentIndex], self.viewPageBar.currentIndex)
        self.viewPageBar.contentViewEndScroll()
    }
}

// MARK: - ViewPageBarDelegate
extension ViewPagerController : ViewPageBarDelegate {
    
    func viewPageBar(_ viewPageBar: ViewPageBar, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
        self.didselected?(viewPageBar, index)
    }
}

public struct PagerItem {
    
    var title: String
    var `class`: UIViewController
    
    public init(_ title: String, cls: UIViewController) {
        self.title = title
        self.class = cls
    }
}


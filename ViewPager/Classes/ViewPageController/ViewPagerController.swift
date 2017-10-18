//
//  ViewPagerController.swift
//  Elegant
//
//  Created by Steve on 29/09/2017.
//  Copyright © 2017 KingCQ. All rights reserved.
//

import UIKit

public class ViewPagerController: UIViewController {
    
    fileprivate var titles : [String]!
    fileprivate var style : StyleCustomizable!
    fileprivate var childVcs : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    
    fileprivate var viewPageBar : ViewPageBar!
    fileprivate var contentView : PageContentView!
    public var didselected: ((_ viewPageBar: ViewPageBar, _ index: Int) -> Void)?
    public var pageViewDidAppear: ((_ viewController: UIViewController, _ index: Int) -> Void)?

    public convenience init(frame: CGRect, titles : [String], style : StyleCustomizable, childVcs : [UIViewController]) {
        self.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .blue
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = self
        parentVc.automaticallyAdjustsScrollViewInsets = false
        setupUI()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentView.viewWillLayoutSubviews()
        viewPageBar.viewWillLayoutSubviews()
        contentView.setCurrentIndex(viewPageBar.currentIndex)
    }
        
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewPageBar.style.isShowBottomLine == true {
            viewPageBar.setupBottomLine()
        }
        let indexPathForFirst = IndexPath(item: viewPageBar.currentIndex, section: 0)
        viewPageBar.collectionView.selectItem(at: indexPathForFirst, animated: false, scrollPosition: .left)
        viewPageBar.collectionView(viewPageBar.collectionView, didSelectItemAt: indexPathForFirst)
    }
}


extension ViewPagerController {
    
    fileprivate func setupUI() {
        let titleH : CGFloat = style.titleHeight
        viewPageBar = ViewPageBar(frame: .zero, titles: titles, style : style)
        viewPageBar.delegate = self
        view.addSubview(viewPageBar)
        viewPageBar.snp.makeConstraints { (make) in
            make.right.left.equalTo(self.view)
            make.height.equalTo(titleH)
            make.top.equalTo(self.view.snp.top)
        }
        contentView = PageContentView(frame: .zero, childVcs: childVcs, parentViewController: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.viewPageBar.snp.bottom)
        }
    }
}


// MARK:- 设置ContentView的代理
extension ViewPagerController : ContentViewDelegate {
    
    func contentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        viewPageBar.updateProgress(progress, fromIndex: sourceIndex, toIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: PageContentView) {
        self.pageViewDidAppear?(self.childVcs[self.viewPageBar.currentIndex], self.viewPageBar.currentIndex)
    }
}


// MARK:- 设置viewPageBar的代理
extension ViewPagerController : ViewPageBarDelegate {
    
    func viewPageBar(_ viewPageBar: ViewPageBar, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
        self.didselected?(viewPageBar, index)
    }
}


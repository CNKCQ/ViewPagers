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
    
    fileprivate var titleView : ViewPageBar!
    fileprivate var contentView : PageContentView!

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
        titleView.viewWillLayoutSubviews()
        contentView.setCurrentIndex(titleView.currentIndex)
    }
        
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if titleView.style.isShowBottomLine == true {
            titleView.setupBottomLine()
        }
        let indexPathForFirst = IndexPath(item: titleView.currentIndex, section: 0)
        titleView.collectionView.selectItem(at: indexPathForFirst, animated: false, scrollPosition: .left)
        titleView.collectionView(titleView.collectionView, didSelectItemAt: indexPathForFirst)
    }
}


extension ViewPagerController {
    
    fileprivate func setupUI() {
        let titleH : CGFloat = style.titleHeight
        titleView = ViewPageBar(frame: .zero, titles: titles, style : style)
        titleView.delegate = self
        view.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
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
            make.top.equalTo(self.titleView.snp.bottom)
        }
    }
}


// MARK:- 设置ContentView的代理
extension ViewPagerController : ContentViewDelegate {
    
    func contentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.updateProgress(progress, fromIndex: sourceIndex, toIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: PageContentView) {    }
}


// MARK:- 设置TitleView的代理
extension ViewPagerController : ViewPageBarDelegate {
    
    func viewPageBar(_ viewPageBar: ViewPageBar, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}


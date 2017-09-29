//
//  PageView.swift
//  Pods
//
//  Created by Jack on 2017/7/2.
//
//

import UIKit

public class PageView: UIView {
    
    fileprivate var titles : [String]!
    fileprivate var style : TitleStyle!
    fileprivate var childVcs : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    
    fileprivate var titleView : TitleView!
    fileprivate var contentView : ContentView!
    fileprivate var didSelected: ((Int) -> Void)?
    fileprivate var viewDidAppear: ((UIViewController?, Int) -> Void)?
    
    public init(frame: CGRect, titles : [String], style : TitleStyle, childVcs : [UIViewController], parentVc : UIViewController, didSelected: ((Int) -> Void)?
        = nil, viewDidAppear: ((UIViewController?, Int) -> Void)? = nil) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.didSelected = didSelected
        self.viewDidAppear = viewDidAppear
        parentVc.automaticallyAdjustsScrollViewInsets = false
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func viewDidLayoutSubviews() {
        contentView.viewDidLayoutSubviews()
        delay(after: 0.00001) { [weak self] in
            self?.contentView.setCurrentIndex(self?.titleView.currentIndex ?? 0)
        }
    }
    
    func delay(after: TimeInterval, execute: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + after
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            execute()
        }
    }
}


extension PageView {
    fileprivate func setupUI() {
        let titleH : CGFloat = style.titleHeight
        titleView = TitleView(frame: .zero, titles: titles, style : style)
        titleView.delegate = self
        addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.height.equalTo(titleH)
            make.top.equalTo(self.snp.top)
        }
        contentView = ContentView(frame: .zero, childVcs: childVcs, parentViewController: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self.titleView.snp.bottom)
        }
    }
}


// MARK:- 设置ContentView的代理
extension PageView : ContentViewDelegate {
    func contentView(_ contentView: ContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func viewDidAppear(_ page: UIViewController?, index: Int) {
        self.viewDidAppear?(page, index)
    }
}


// MARK:- 设置TitleView的代理
extension PageView : TitleViewDelegate {
    
    func titleView(_ titleView: TitleView, selectedIndex index: Int) {
        self.didSelected?(index)
        contentView.setCurrentIndex(index)
    }
}



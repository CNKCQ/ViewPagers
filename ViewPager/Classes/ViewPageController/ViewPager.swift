//
//  ViewPagerController.swift
//  Elegant
//
//  Created by Steve on 29/09/2017.
//  Copyright © 2017 KingCQ. All rights reserved.
//

import UIKit

public protocol ViewPagerDelegate: class {
    
    func viewPager(_ viewPager: ViewPager, didSelected index: Int)
    
    func viewPager(_ viewPager: ViewPager, willAppear cell: UICollectionViewCell, at index: Int)
    
}

public protocol ViewPagerDataSource: class {
    
    func titlesOfViewPager() -> [String]
    
    func viewPager(_ cell: UICollectionViewCell, index: Int) -> UICollectionViewCell
}

public class ViewPager: UIView {
    
    public var style : StyleCustomizable?
    
    public weak var dataSource: ViewPagerDataSource?
    
    public weak var delegate: ViewPagerDelegate?
    
    public var viewPagerBar : ViewPagerBar!
    
    fileprivate var contentView : PagerContentView!
    
    public var currentIndex: Int = 0 {
        didSet {
            self.set(current: currentIndex)
        }
    }

    
    public var titles : [String] = [] {
        didSet {
            self.viewPagerBar?.titles = titles
        }
    }
    
    public var isViewPagerBarHidden: Bool = false {
        didSet {
            let height: CGFloat = isViewPagerBarHidden ? 0 : self.viewPagerBar.style.titleHeight
            self.viewPagerBar.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            self.viewPagerBar.superview?.layoutIfNeeded()
        }
    }

    public convenience init(_ style: StyleCustomizable) {
        self.init(frame: .zero)
        self.style = style
        setupContentView()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData() {
        self.viewPagerBar.collectionView.reloadData()
        self.contentView.collectionView.reloadData()
        let count = (self.dataSource?.titlesOfViewPager() ?? []).count
        delay(after: 0.001) { [weak self] in
            guard let `self` = self else {
                return
            }
            if self.currentIndex >= count-1 {
                self.currentIndex = count-1
            } else {
                self.set(current: self.currentIndex)
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        viewPagerBar.collectionView.collectionViewLayout.invalidateLayout()
        contentView.collectionView.collectionViewLayout.invalidateLayout()
        self.set(current: currentIndex)
    }
    
    func set(current index: Int) {
        self.viewPagerBar.currentIndex = index
        self.contentView.currentIndex = index
    }
    
    public func delay(after: TimeInterval, execute: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + after
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            execute()
        }
    }

}


extension ViewPager {
    
    fileprivate func setupContentView() {
        guard let style = self.style else {
            return
        }
        let titleH : CGFloat = style.titleHeight
        viewPagerBar = ViewPagerBar(frame: .zero, style : style)
        viewPagerBar.dataSource = self
        viewPagerBar.delegate = self
        addSubview(viewPagerBar)
        viewPagerBar.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.height.equalTo(titleH)
            make.top.equalTo(self.snp.top)
        }
        contentView = PagerContentView(frame: .zero)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.dataSource = self
        contentView.delegate = self
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self.viewPagerBar.snp.bottom)
        }
    }
}

extension ViewPager: ContentViewDataSource {
    
    func numberOfItem() -> Int {
        return self.dataSource?.titlesOfViewPager().count ?? 0
    }
    
    func contentView(_ cell: UICollectionViewCell, index: Int) -> UICollectionViewCell {
        return self.dataSource?.viewPager(cell, index: index) ?? UICollectionViewCell()
    }

}

// MARK: - ContentViewDelegate
extension ViewPager : ContentViewDelegate {
    
    func contentView(_ contentView: PagerContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        viewPagerBar.updateProgress(progress, fromIndex: sourceIndex, toIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: PagerContentView) {
        self.currentIndex = Int(contentView.collectionView.contentOffset.x / contentView.collectionView.frame.width)
    }
    
    func contentView(_ contentView: PagerContentView, willAppear cell: UICollectionViewCell, at index: Int) {
        self.delegate?.viewPager(self, willAppear: cell, at: index)
    }
}

extension ViewPager: ViewPagerBarDataSource {    
    
    func titlesOfPagerBar() -> [String] {
        return self.dataSource?.titlesOfViewPager() ?? []
    }
    
}

// MARK: - ViewPageBarDelegate
extension ViewPager : ViewPagerBarDelegate {    
    
    func viewPagerBar(_ viewPagerBar: ViewPagerBar, selectedIndex index: Int) {
        self.currentIndex = index
        self.delegate?.viewPager(self, didSelected: index)
    }
}

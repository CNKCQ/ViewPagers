//
//  PageContentView.swift
//  Pods-ViewPager_Example
//
//  Created by Steve on 17/10/2017.
//

import UIKit

enum PagerScrollingDirection {
    case left
    case right
}

@objc protocol ContentViewDelegate : class {
    
    func contentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex : Int, targetIndex : Int)
    
    @objc optional func contentViewEndScroll(_ contentView: PageContentView)
}

private let kContentCellID = "kContentCellID"

class PageContentView: UIView {
    
    weak var delegate : ContentViewDelegate?
    
    fileprivate var childViewControllers : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    fileprivate var isForbidScrollDelegate : Bool = false
    fileprivate var startOffsetX : CGFloat = 0
    var direction: PagerScrollingDirection = .left
    
    public lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    init(frame: CGRect, childViewControllers : [UIViewController], parentViewController : UIViewController) {
        super.init(frame: frame)
        
        self.childViewControllers = childViewControllers
        self.parentVc = parentViewController
        
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}


// MARK:- setup the content
extension PageContentView {
    
    fileprivate func setupCollectionView() {

        for vc in childViewControllers {
            parentVc.addChildViewController(vc)
        }
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}


// MARK:- UICollectionViewDataSource
extension PageContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let childVc = childViewControllers[indexPath.item]
        cell.contentView.addSubview(childVc.view)
        childVc.view.snp.makeConstraints { (make) in
            make.edges.equalTo(cell.contentView)
        }
        return cell
    }
}


// MARK:- UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension PageContentView : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if isForbidScrollDelegate { return }
        
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // left dragging
            self.direction = .left
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            targetIndex = sourceIndex + 1
            if targetIndex >= childViewControllers.count {
                targetIndex = childViewControllers.count - 1
            }
            
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // right dragging
            self.direction = .right
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            sourceIndex = targetIndex + 1
            if sourceIndex >= childViewControllers.count {
                sourceIndex = childViewControllers.count - 1
            }
        }
        
        delegate?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.contentViewEndScroll?(self)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
}

extension PageContentView {
    
    func setCurrentIndex(_ currentIndex : Int) {
        
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}

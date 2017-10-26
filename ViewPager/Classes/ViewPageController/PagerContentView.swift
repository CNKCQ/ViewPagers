//
//  PagerContentView.swift
//  Pods-ViewPager_Example
//
//  Created by Steve on 17/10/2017.
//

import UIKit


@objc protocol ContentViewDelegate : class {
    
    func contentView(_ contentView: PagerContentView, progress: CGFloat, sourceIndex : Int, targetIndex : Int)
    
    @objc optional func contentViewEndScroll(_ contentView: PagerContentView)
    
    func contentView(_ contentView: PagerContentView, willAppear cell: UICollectionViewCell, at index: Int)
    
}

@objc protocol ContentViewDataSource: class {
    
    func numberOfItem() -> Int
    
    func contentView(_ cell: UICollectionViewCell, index: Int) -> UICollectionViewCell
}

private let kContentCellID = "kContentCellID"

class PagerContentView: UIView {
    
    weak var delegate : ContentViewDelegate?
    
    weak var dataSource: ContentViewDataSource?
    
    var currentIndex: Int = 0 {
        didSet {
            self.setCurrentIndex(currentIndex)
        }
    }
    
    fileprivate var isForbidScrollDelegate : Bool = false
    fileprivate var startOffsetX : CGFloat = 0
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
extension PagerContentView {
    
    fileprivate func setupCollectionView() {
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}


// MARK:- UICollectionViewDataSource
extension PagerContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.numberOfItem() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        _ = self.dataSource?.contentView(cell, index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("🌹", sourceIndexPath, destinationIndexPath)
    }
}


// MARK:- UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension PagerContentView : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        var targetIndex : Int = 0
        
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        let count = self.dataSource?.numberOfItem() ?? 0
        if currentOffsetX > startOffsetX { // left dragging
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            targetIndex = currentIndex + 1
            if targetIndex >= count {
                targetIndex = count - 1
            }
            if currentOffsetX - startOffsetX >= scrollViewW {
                progress = 1
                targetIndex = currentIndex
                return
            }
        } else { // right dragging
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targetIndex = Int(currentOffsetX / scrollViewW)
        }
        delegate?.contentView(self, progress: progress, sourceIndex: currentIndex, targetIndex: targetIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.contentViewEndScroll?(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.delegate?.contentView(self, willAppear: cell, at: indexPath.item)
    }
}

extension PagerContentView {
    
    func setCurrentIndex(_ currentIndex : Int) {
        isForbidScrollDelegate = true
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}

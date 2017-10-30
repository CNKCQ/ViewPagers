//
//  ViewPagerBar.swift
//  Pods
//
//  Created by Jack on 2017/7/2.
//
//


import UIKit
import SnapKit

// MARK:- ViewPagerBarDelegate
protocol ViewPagerBarDelegate : class {
    
    func viewPagerBar(_ ViewPagerBar : ViewPagerBar, selectedIndex index : Int)
    
}

protocol ViewPagerBarDataSource: class {
    
    func titlesOfPagerBar() -> [String]
}


public class ViewPagerBar: UIView {
    
    weak var delegate : ViewPagerBarDelegate?
    weak var dataSource: ViewPagerBarDataSource?
    
    var currentIndex : Int = 0 {
        willSet {
            for index in 0..<(self.dataSource?.titlesOfPagerBar() ?? []).count {
                guard let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? PagerBarItem else {
                    return
                }
                cell.titleLabel.textColor = style.normalColor
                cell.titleLabel.font = style.font
            }
        }
        didSet {
            guard let cell = self.collectionView?.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? PagerBarItem else {
                return
            }
            UIView.animate(withDuration: 0.25, animations: {
                cell.titleLabel.textColor = self.style.selectedColor
                cell.titleLabel.font = self.style.scaleFont
                self.bottomLine.center = CGPoint(x: cell.center.x, y: self.bottomLine.center.y)
            }) { (_) in
                if self.currentIndex < 2 { return }
                self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    var titles : [String] = []
    
    var style : StyleCustomizable = DefaultPagerStyle() {
        didSet {
            backgroundColor = style.titleBgColor
        }
    }
    
    var isInit: Bool = true
    
    var collectionView: UICollectionView!
    
    var bottomoffset: CGFloat = 5
    
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    
    fileprivate lazy var normalColor : (r : CGFloat, g : CGFloat, b : CGFloat) = self.rgb(self.style.normalColor)
    
    fileprivate lazy var selectedColor : (r : CGFloat, g : CGFloat, b : CGFloat) = self.rgb(self.style.selectedColor)
    
    convenience init(frame: CGRect, style : StyleCustomizable) {
        self.init(frame: frame)
        self.style = style
        setupCollectionView()
        self.clipsToBounds = true
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewWillLayoutSubviews() {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func viewDidLayoutSubviews() {
        if titles.count < 2 {
            return
        }
        let indexPath = IndexPath(item: self.currentIndex, section: 0)
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.collectionView(self.collectionView, didSelectItemAt: indexPath)
    }
    
}

// MARK: - randering ui
extension ViewPagerBar {
    
    fileprivate func setupCollectionView() {
        let layout = ViewPagerBarLayout(self)
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.register(PagerBarItem.self, forCellWithReuseIdentifier: PagerBarItem.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        layout.minimumLineSpacing =  style.titleMargin
        layout.minimumInteritemSpacing =  style.titleMargin
        collectionView.contentInset = UIEdgeInsets(top: 0, left: style.isSplit == true ? style.titleMargin : 0, bottom: 0, right:  style.isSplit == true ? -style.titleMargin : 0)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        collectionView.backgroundColor = style.titleBgColor
    }
    
    func frmaeOfCellAt(_ index: Int) -> CGRect {
        let layoutAttributes: UICollectionViewLayoutAttributes? = self.collectionView?.layoutAttributesForItem(at: IndexPath(item: index, section: 0))
        return layoutAttributes?.frame ?? .zero
    }
}

extension ViewPagerBar: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.titles = self.dataSource?.titlesOfPagerBar() ?? []
        return self.titles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PagerBarItem.reuseIdentifier, for: indexPath) as? PagerBarItem else {
            fatalError("not found the right cell")
        }
        cell.titleLabel.font = style.font
        cell.titleLabel.textColor = style.normalColor
        cell.titleLabel.text = titles[indexPath.item]
        return cell
    }
}

extension ViewPagerBar: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fromCell: PagerBarItem? = collectionView.cellForItem(at: IndexPath(item: self.currentIndex, section: 0)) as? PagerBarItem

        fromCell?.titleLabel.textColor = style.normalColor
        fromCell?.titleLabel.font = style.font
        guard let toCell: PagerBarItem = collectionView.cellForItem(at: indexPath) as? PagerBarItem else {
            return
        }
        toCell.titleLabel.textColor = self.style.selectedColor
        toCell.titleLabel.font = style.scaleFont
        UIView.animate(withDuration: 0.25) {
            self.bottomLine.center = CGPoint(x: toCell.center.x, y: self.bottomLine.center.y)
        }
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.viewPagerBar(self, selectedIndex: indexPath.item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell: PagerBarItem? = collectionView.cellForItem(at: indexPath) as? PagerBarItem
        selectedCell?.titleLabel.textColor = style.normalColor
        selectedCell?.titleLabel.font = style.font
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 0, isInit == true {
            guard let cell = cell as? PagerBarItem else {
                return
            }
            bottomLine.removeFromSuperview()
            self.collectionView.addSubview(bottomLine)
            cell.isSelected = true
            cell.titleLabel.textColor = style.selectedColor
            cell.titleLabel.font = style.scaleFont
            self.bottomLine.frame = CGRect(x: (cell.frame.width - style.bottomLineW) / 2, y: cell.frame.height - style.bottomLineH - style.bottomLineOffset, width: style.bottomLineW, height: style.bottomLineH)
            isInit = false
        }
    }
    
}

extension ViewPagerBar: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize = (self.titles[indexPath.item] as NSString).size(withAttributes: [NSAttributedStringKey.font: style.font])

        if style.isSplit == true {
            return CGSize(width: (collectionView.bounds.width - (style.titleMargin * CGFloat(self.titles.count + 1))) / CGFloat(self.titles.count), height: collectionView.bounds.height)
        }
        if style.titleWidth != 0 {
            return CGSize(width: style.titleWidth, height: self.frame.height)
        }
        return CGSize(width: size.width + 8, height: self.frame.height)
    }
}

extension ViewPagerBar {
    
    func updateProgress(_ progress : CGFloat, fromIndex : Int, toIndex : Int) {
        guard let sourceItem = self.collectionView.cellForItem(at: IndexPath(item: fromIndex, section: 0)) as? PagerBarItem else {
            return
        }
        guard let targetItem = self.collectionView.cellForItem(at: IndexPath(item: toIndex, section: 0)) as? PagerBarItem else {
            return
        }
        let colorDelta = (selectedColor.0 - normalColor.0, selectedColor.1 - normalColor.1, selectedColor.2 - normalColor.2)
        let fontDelta = (style.scaleFont.pointSize - style.font.pointSize)
        sourceItem.titleLabel.font = UIFont.systemFont(ofSize: (style.scaleFont.pointSize - fontDelta * progress))
        targetItem.titleLabel.font = UIFont.systemFont(ofSize: (style.scaleFont.pointSize + fontDelta * progress))
        sourceItem.titleLabel.textColor = UIColor(r: selectedColor.0 - colorDelta.0 * progress, g: selectedColor.1 - colorDelta.1 * progress, b: selectedColor.2 - colorDelta.2 * progress)
        targetItem.titleLabel.textColor = UIColor(r: normalColor.0 + colorDelta.0 * progress, g: normalColor.1 + colorDelta.1 * progress, b: normalColor.2 + colorDelta.2 * progress)
        
        let bottomLineFromCenterX = sourceItem.center.x
        let marginWidth: CGFloat = fabs(targetItem.center.x - sourceItem.center.x)
        let progressWidth: CGFloat = progress * (targetItem.frame.width + style.titleMargin)
        let bottomLineToCenterX =  toIndex > fromIndex ? bottomLineFromCenterX + progressWidth : bottomLineFromCenterX - progressWidth
        if style.isAnimateWithProgress, progress < 1 {
            self.bottomLine.center = CGPoint(x: bottomLineToCenterX, y: self.bottomLine.center.y)
        } else if progressWidth * 2 > marginWidth {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.center = CGPoint(x: targetItem.center.x, y: self.bottomLine.center.y)
            }, completion: { (_) in
                self.collectionView.scrollToItem(at: IndexPath(item: toIndex, section: 0), at: .centeredHorizontally, animated: true)
            })
        }
    }
}

// MARK:- get the cgfloat of the color
extension ViewPagerBar {
    
    fileprivate func rgb(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        return (color.components[0] * 255, color.components[1] * 255, color.components[2] * 255)
    }

}


//
//  ViewPagerBarLayout.swift
//  ViewPager
//
//  Created by Steve on 17/10/2017.
//

import Foundation

class ViewPagerBarLayout: UICollectionViewFlowLayout {
    
    var ViewPagerBar: ViewPagerBar!
    
    convenience init(_ ViewPagerBar: ViewPagerBar){
        self.init()
        self.ViewPagerBar = ViewPagerBar
        self.scrollDirection = .horizontal
    }
    
    public func layoutIfNeeded() {
        let layout: UICollectionViewFlowLayout? = self.ViewPagerBar.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = self.ViewPagerBar.style.titleMargin
        layout?.minimumInteritemSpacing = self.ViewPagerBar.style.titleMargin
    }
}

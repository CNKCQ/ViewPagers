//
//  ViewPageBarLayout.swift
//  ViewPager
//
//  Created by Steve on 17/10/2017.
//

import Foundation

class ViewPageBarLayout: UICollectionViewFlowLayout {
    
    var viewPageBar: ViewPageBar!
    
    convenience init(_ viewPageBar: ViewPageBar){
        self.init()
        self.viewPageBar = viewPageBar
        self.scrollDirection = .horizontal
    }
    
    public func layoutIfNeeded() {
        let layout: UICollectionViewFlowLayout? = self.viewPageBar.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = self.viewPageBar.style.titleMargin
        layout?.minimumInteritemSpacing = self.viewPageBar.style.titleMargin
    }
}

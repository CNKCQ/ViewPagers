//
//  PageViewController.swift
//  ViewPager
//
//  Created by Jack on 2017/7/2.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

class PageViewController: UIViewController {
    
    var titleLabel: UILabel {
        return UILabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.frame = view.bounds
        titleLabel.textColor = UIColor.random
        titleLabel.text = self.title
        view.addSubview(titleLabel)
    }
}

public extension UIColor {
    
    /// Returns random UIColor with random alpha(default: 1.0)
    static var random: UIColor {
        return UIColor(
            red: CGFloat(arc4random_uniform(256)) / CGFloat(255),
            green: CGFloat(arc4random_uniform(256)) / CGFloat(255),
            blue: CGFloat(arc4random_uniform(256)) / CGFloat(255),
            alpha: 1.0
        )
    }
}

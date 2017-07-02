//
//  PageViewController.swift
//  ViewPager
//
//  Created by Jack on 2017/7/2.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.random
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

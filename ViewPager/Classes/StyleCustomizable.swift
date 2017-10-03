//
//  ViewPagerStyle.swift
//  Pods
//
//  Created by Jack on 2017/7/2.
//
//


import UIKit

public protocol StyleCustomizable {
    
    /// 是否是滚动的Title
    var isScrollEnable : Bool { get }
    
    /// 普通Title颜色
    var normalColor : UIColor { get }
    
    /// 选中Title颜色
    var selectedColor : UIColor { get }
    
    /// 滚动Title的字体间距
    var titleMargin : CGFloat { get }
    
    /// viewPageBar的高度
    var titleHeight : CGFloat { get }
    
    /// viewPageBar's backgroundColor
    var titleBgColor : UIColor { get }
    
    /// Title字体大小
    var font : UIFont { get }

    
    /// 是否显示底部滚动条
    var isShowBottomLine: Bool { get }
    
    /// 底部滚动条的颜色
    var bottomLineColor : UIColor { get }
    
    /// 底部滚动条的高度
    var bottomLineH: CGFloat { get }
    
    var bottomLineMargin: CGFloat { get }
    
    var isShowPageBar: Bool { get }
}

public extension StyleCustomizable {
    
    /// 是否是滚动的Title
    var isScrollEnable : Bool {
        return true
    }
    
    /// 普通Title颜色
    var normalColor : UIColor {
        return UIColor(r: 0, g: 0, b: 0)
    }
    
    /// 选中Title颜色
    var selectedColor : UIColor {
        return UIColor(r: 255, g: 127, b: 0)
    }
    
    /// 滚动Title的字体间距
    var titleMargin : CGFloat {
        return 20
    }
    
    /// viewPageBar的高度
    var titleHeight : CGFloat {
        return 44
    }
    
    /// viewPageBar's backgroundColor
    var titleBgColor : UIColor {
        return UIColor.clear
    }
    
    /// Title字体大小
    var font : UIFont {
        return UIFont.systemFont(ofSize: 14.0)
    }
    
    /// 是否显示底部滚动条
    var isShowBottomLine: Bool {
        return true
    }
    
    /// 底部滚动条的颜色
    var bottomLineColor : UIColor {
        return UIColor.orange
    }
    
    /// 底部滚动条的高度
    var bottomLineH : CGFloat {
        return 2
    }
    
    var bottomLineMargin: CGFloat {
        return 0
    }

    
    var isShowPageBar: Bool {
        return true
    }
    
}

struct DefaultPagerStyle: StyleCustomizable {}


public extension UIColor {
    
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            alpha: 1.0
        )
    }
    
    /// Returns random UIColor with random alpha(default: 1.0)
    static var random: UIColor {
        return UIColor(
            red: CGFloat(arc4random_uniform(256)) / CGFloat(255),
            green: CGFloat(arc4random_uniform(256)) / CGFloat(255),
            blue: CGFloat(arc4random_uniform(256)) / CGFloat(255),
            alpha: 1.0
        )
    }
    
    /// Return rgba components of `self`
    var components: [CGFloat] {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return [r, g, b, a]
    }
}


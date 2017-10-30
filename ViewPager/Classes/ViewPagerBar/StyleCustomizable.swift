//
//  ViewPagerStyle.swift
//  Pods
//
//  Created by Jack on 2017/7/2.
//
//


import UIKit

public protocol StyleCustomizable {
    
    /// PagerBarItem should be scroll
    var isScrollEnable : Bool { get }
    
    /// the color of deselected item
    var normalColor : UIColor { get }
    
    /// the color of the selected item
    var selectedColor : UIColor { get }
    
    /// the margin of the PagerBarItem
    var titleMargin : CGFloat { get }
    
    /// ViewPagerBar's height
    var titleHeight : CGFloat { get }
    
    /// title width
    var titleWidth : CGFloat { get }
    
    /// ViewPagerBar's backgroundColor
    var titleBgColor : UIColor { get }
    
    /// the item text font
    var font : UIFont { get }

    var scaleFont: UIFont { get }
    
    /// 是否显示底部滚动条
    var isShowBottomLine: Bool { get }
    
    /// 底部滚动条的颜色
    var bottomLineColor : UIColor { get }
    
    /// 底部滚动条的高度
    var bottomLineH: CGFloat { get }
    
    /// 底部滚动条的宽度
    var bottomLineW: CGFloat { get }
    
    var bottomLineOffset: CGFloat { get }
    
    /// should split the screen width
    var isSplit: Bool { get }
    
    var isAnimateWithProgress: Bool { get }
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
        return 4
    }
    
    /// ViewPagerBar的高度
    var titleHeight : CGFloat {
        return 44
    }
    
    var titleWidth : CGFloat {
        return 0
    }

    
    /// ViewPagerBar's backgroundColor
    var titleBgColor : UIColor {
        return UIColor.clear
    }
    
    /// Title字体大小
    var font : UIFont {
        return UIFont.systemFont(ofSize: 14.0)
    }
    
    var scaleFont: UIFont {
        return font
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
        return 10
    }
    
    /// 底部滚动条的宽度
    var bottomLineW: CGFloat {
        return 50
    }
    
    var bottomLineOffset: CGFloat {
        return 5
    }

    var isSplit: Bool {
        return false
    }
    
    var isAnimateWithProgress: Bool {
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


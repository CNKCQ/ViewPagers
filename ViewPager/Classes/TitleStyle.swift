//
//  TitleStyle.swift
//  Pods
//
//  Created by Jack on 2017/7/2.
//
//


import UIKit

public struct TitleStyle {
    /// 是否是滚动的Title
    var isScrollEnable : Bool = true
    /// 普通Title颜色
    var normalColor : UIColor = UIColor(r: 0, g: 0, b: 0)
    /// 选中Title颜色
    var selectedColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    /// Title字体大小
    var font : UIFont = UIFont.systemFont(ofSize: 14.0)
    /// 滚动Title的字体间距
    var titleMargin : CGFloat = 20
    /// titleView的高度
    var titleHeight : CGFloat = 44
    /// titleView的北京颜色
    var titleBgColor : UIColor = .clear
    /// 是否显示底部滚动条
    var isShowBottomLine : Bool = false
    /// 底部滚动条的颜色
    var bottomLineColor : UIColor = UIColor.orange
    /// 底部滚动条的高度
    var bottomLineH : CGFloat = 2
    /// 是否进行缩放
    var isNeedScale : Bool = false
    var scaleRange : CGFloat = 1.2
    /// 是否显示遮盖
    var isShowCover : Bool = false
    /// 遮盖背景颜色
    var coverBgColor : UIColor = UIColor.lightGray
    /// 文字&遮盖间隙
    var coverMargin : CGFloat = 5
    /// 遮盖的高度
    var coverH : CGFloat = 25
    /// 遮盖的宽度
    var coverW : CGFloat = 0
    /// 设置圆角大小
    var coverRadius : CGFloat = 12
    
    public init(
            isScrollEnable : Bool = true,
            normalColor : UIColor = UIColor(r: 0, g: 0, b: 0),
            selectedColor : UIColor = UIColor(r: 255, g: 127, b: 0),
            font : UIFont = UIFont.systemFont(ofSize: 14.0),
            titleMargin : CGFloat = 20,
            titleHeight : CGFloat = 44,
            titleBgColor : UIColor = .clear,
            isShowBottomLine : Bool = false,
            bottomLineColor : UIColor = UIColor.orange,
            bottomLineH : CGFloat = 2,
            isNeedScale : Bool = false,
            scaleRange : CGFloat = 1.2,
            isShowCover : Bool = false,
            coverBgColor : UIColor = UIColor.lightGray,
            coverMargin : CGFloat = 5,
            coverH : CGFloat = 25,
            coverW : CGFloat = 0,
            coverRadius : CGFloat = 12
        ) {
        self.isScrollEnable = isScrollEnable
        self.normalColor = normalColor
        self.selectedColor = selectedColor
        self.font = font
        self.titleMargin = titleMargin
        self.titleHeight = titleHeight
        self.titleBgColor = titleBgColor
        self.isShowBottomLine = isShowBottomLine
        self.bottomLineColor = bottomLineColor
        self.bottomLineH = bottomLineH
        self.isNeedScale = isNeedScale
        self.scaleRange = scaleRange
        self.isShowCover = isShowCover
        self.coverBgColor = coverBgColor
        self.coverMargin = coverMargin
        self.coverH = coverH
        self.coverW = coverW
        self.coverRadius = coverRadius
        
    }
}

public extension UIColor {
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    static var random: UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}


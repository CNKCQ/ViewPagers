//
//  TitleView.swift
//  Pods
//
//  Created by Jack on 2017/7/2.
//
//


import UIKit
import SnapKit

// MARK:- 定义协议
protocol TitleViewDelegate : class {
    
    func titleView(_ titleView : TitleView, selectedIndex index : Int)
    
}

class TitleView: UIView {
    
    weak var delegate : TitleViewDelegate?
    
    fileprivate var titles : [String]!
    fileprivate var style : TitleStyle!
    var currentIndex : Int = 0
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    
    // MARK: 计算属性
    fileprivate lazy var normalColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(self.style.normalColor)
    
    fileprivate lazy var selectedColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(self.style.selectedColor)
    
    // MARK: 自定义构造函数
    init(frame: CGRect, titles : [String], style : TitleStyle) {
        super.init(frame: frame)
        
        self.titles = titles
        self.style = style
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI界面内容
extension TitleView {
    fileprivate func setupUI() {
        // 0.设置自己的背景
        backgroundColor = style.titleBgColor
        
        // 2.设置所有的标题Label
        setupTitleLabels()
        
        // 3.设置Label的位置
        setupTitleLabelsPosition()
        
        // 4.设置底部的滚动条
        if style.isShowBottomLine {
            setupBottomLine()
        }
    }
    
    fileprivate func setupTitleLabels() {
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.tag = index
            label.text = title
            label.textColor = index == 0 ? style.selectedColor : style.normalColor
            label.font = style.font
            label.textAlignment = .center
            
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_ :)))
            label.addGestureRecognizer(tapGes)
            titleLabels.append(label)
            addSubview(label)
        }
    }
    
    
    fileprivate func setupTitleLabelsPosition() {
        
        let count = titles.count
        if count <= 5 {
            for (index, label) in titleLabels.enumerated() {
                label.backgroundColor = UIColor.random
                if index == 0 {
                    label.snp.makeConstraints({ (make) in
                        make.left.equalTo(self.snp.left)
                        make.top.equalTo(self.snp.top)
                        make.height.equalTo(self.snp.height).offset(-4)
                    })
                } else if index == count - 1 {
                    label.snp.makeConstraints({ (make) in
                        make.top.height.width.equalTo(titleLabels[index - 1])
                        make.right.equalTo(self.snp.right)
                        make.left.equalTo(titleLabels[index - 1].snp.right)
                        make.width.equalTo(titleLabels[index - 1].snp.width)
                    })
                } else {
                    label.snp.makeConstraints({ (make) in
                        make.top.height.equalTo(titleLabels[index - 1])
                        make.width.equalTo(titleLabels[index - 1].snp.width)
                        make.left.equalTo(titleLabels[index - 1].snp.right)
                    })
                }
            }
        }
    }
    
    fileprivate func setupBottomLine() {
        addSubview(bottomLine)
        guard let firstTitleLabel = titleLabels.first else {
            return
        }
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.width.equalTo(firstTitleLabel)
            make.top.equalTo(firstTitleLabel.snp.bottom)
            make.height.equalTo(style.bottomLineH)
        }
    }
    
    fileprivate func setupCoverView() {}
}


// MARK:- 事件处理
extension TitleView {
    @objc fileprivate func titleLabelClick(_ tap : UITapGestureRecognizer) {
        // 0.获取当前Label
        guard let currentLabel = tap.view as? UILabel else { return }
        
        // 1.如果是重复点击同一个Title,那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        // 2.获取之前的Label
        let oldLabel = titleLabels[currentIndex]
        
        // 3.切换文字的颜色
        currentLabel.textColor = style.selectedColor
        oldLabel.textColor = style.normalColor
        
        // 4.保存最新Label的下标值
        currentIndex = currentLabel.tag
        
        // 5.通知代理
        delegate?.titleView(self, selectedIndex: currentIndex)
        
        // 7.调整bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLine.snp.remakeConstraints({ (make) in
                    make.left.right.equalTo(currentLabel)
                    make.top.equalTo(currentLabel.snp.bottom)
                    make.height.equalTo(self.style.bottomLineH)
                })
                self.layoutIfNeeded()
            })
        }
    }
}

// MARK:- 对外暴露的方法
extension TitleView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]

        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (selectedColorRGB.0 - normalColorRGB.0, selectedColorRGB.1 - normalColorRGB.1, selectedColorRGB.2 - normalColorRGB.2)

        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: selectedColorRGB.0 - colorDelta.0 * progress, g: selectedColorRGB.1 - colorDelta.1 * progress, b: selectedColorRGB.2 - colorDelta.2 * progress)

        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: normalColorRGB.0 + colorDelta.0 * progress, g: normalColorRGB.1 + colorDelta.1 * progress, b: normalColorRGB.2 + colorDelta.2 * progress)

        // 4.记录最新的index
        currentIndex = targetIndex

        // 5.计算滚动的范围差值
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLine.snp.remakeConstraints({ (make) in
                    make.left.right.equalTo(targetLabel)
                    make.top.equalTo(targetLabel.snp.bottom)
                    make.height.equalTo(self.style.bottomLineH)
                })
                self.layoutIfNeeded()
            })
        }
    }
}

// MARK:- 获取RGB的值
extension TitleView {
    
    fileprivate func getRGBWithColor(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("请使用RGB方式给Title赋值颜色")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}


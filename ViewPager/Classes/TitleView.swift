//
//  TitleView.swift
//  Pods
//
//  Created by Jack on 2017/7/2.
//
//


import UIKit
import SnapKit

// MARK:- TitleViewDelegate
protocol TitleViewDelegate : class {
    
    func titleView(_ titleView : TitleView, selectedIndex index : Int)
    
}

public class TitleView: UIView {
    
    weak var delegate : TitleViewDelegate?
    
    fileprivate var titles : [String]!
    fileprivate var style : TitleStyle!
    var currentIndex : Int = 0
    var bottomoffset: CGFloat = 5
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    
    fileprivate lazy var normalColor : (r : CGFloat, g : CGFloat, b : CGFloat) = self.rgb(self.style.normalColor)
    
    fileprivate lazy var selectedColor : (r : CGFloat, g : CGFloat, b : CGFloat) = self.rgb(self.style.selectedColor)
    
    init(frame: CGRect, titles : [String], style : TitleStyle) {
        super.init(frame: frame)
        
        self.titles = titles
        self.style = style
        
        setupUI()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - randering ui
extension TitleView {
    fileprivate func setupUI() {
        backgroundColor = style.titleBgColor
        setupTitleLabels()
        setupTitleLabelsPosition()
        if style.isShowBottomLine {
            setupBottomLine()
        }
    }
    
    fileprivate func setupTitleLabels() {
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.backgroundColor = UIColor.random
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
                if index == 0 {
                    label.snp.makeConstraints({ (make) in
                    make.left.equalTo(self.snp.left).offset(style.titleMargin)
                    make.top.equalTo(self.snp.top)
                    make.height.equalTo(self.snp.height).offset(-4)
                    })
                } else if index == count - 1 {
                    label.snp.makeConstraints({ (make) in
                    make.top.height.width.equalTo(titleLabels[index - 1])
                    make.right.equalTo(self.snp.right).offset(-style.titleMargin)
                    make.left.equalTo(titleLabels[index - 1].snp.right).offset(style.titleMargin)
                    make.width.equalTo(titleLabels[index - 1].snp.width)
                    })
                } else {
                    label.snp.makeConstraints({ (make) in
                        make.top.height.equalTo(titleLabels[index - 1])
                        make.width.equalTo(titleLabels[index - 1].snp.width)
                        make.left.equalTo(titleLabels[index - 1].snp.right).offset(style.titleMargin)
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
            make.top.equalTo(firstTitleLabel.snp.bottom).offset(-bottomoffset)
            make.height.equalTo(style.bottomLineH)
        }
    }
    
    fileprivate func setupCoverView() {}
}


extension TitleView {
    @objc fileprivate func titleLabelClick(_ tap : UITapGestureRecognizer) {
        guard let currentLabel = tap.view as? UILabel else { return }
        if currentLabel.tag == currentIndex { return }
        let oldLabel = titleLabels[currentIndex]
        currentLabel.textColor = style.selectedColor
        oldLabel.textColor = style.normalColor
        currentIndex = currentLabel.tag
        delegate?.titleView(self, selectedIndex: currentIndex)
        
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLine.snp.remakeConstraints({ (make) in
                    make.left.right.equalTo(currentLabel)
                    make.top.equalTo(currentLabel.snp.bottom).offset(-self.bottomoffset)
                    make.height.equalTo(self.style.bottomLineH)
                })
                self.layoutIfNeeded()
            })
        }
    }
}

extension TitleView {
    
    func finishProgress(index: Int) {
        let currentLabel = self.titleLabels[index]
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLine.snp.remakeConstraints({ (make) in
                    make.left.equalTo(currentLabel.snp.left)
                    make.width.equalTo(currentLabel.snp.width)
                    make.top.equalTo(currentLabel.snp.bottom).offset(-self.bottomoffset)
                    make.height.equalTo(self.style.bottomLineH)
                })
                self.layoutIfNeeded()
            })
        }
        currentLabel.textColor = UIColor(r: selectedColor.0, g: selectedColor.1, b: selectedColor.2)
        self.titleLabels.filter({$0 != currentLabel})
            .forEach { $0.textColor = UIColor(r: normalColor.0, g: normalColor.1, b: normalColor.2)}
    }
    
    func updateProgress(_ progress : CGFloat, fromIndex : Int, toIndex : Int) {

        let sourceLabel = titleLabels[fromIndex]
        let targetLabel = titleLabels[toIndex]
        let colorDelta = (selectedColor.0 - normalColor.0, selectedColor.1 - normalColor.1, selectedColor.2 - normalColor.2)

        sourceLabel.textColor = UIColor(r: selectedColor.0 - colorDelta.0 * progress, g: selectedColor.1 - colorDelta.1 * progress, b: selectedColor.2 - colorDelta.2 * progress)

        targetLabel.textColor = UIColor(r: normalColor.0 + colorDelta.0 * progress, g: normalColor.1 + colorDelta.1 * progress, b: normalColor.2 + colorDelta.2 * progress)

        currentIndex = toIndex
        let bottomLineFromX = sourceLabel.frame.origin.x
        let bottomLineToX = toIndex > fromIndex ? bottomLineFromX + progress * targetLabel.frame.size.width : bottomLineFromX - progress * targetLabel.frame.size.width
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLine.snp.remakeConstraints({ (make) in
                    make.left.equalTo(bottomLineToX)
                    make.width.equalTo(targetLabel.snp.width)
                    make.top.equalTo(targetLabel.snp.bottom).offset(-self.bottomoffset)
                    make.height.equalTo(self.style.bottomLineH)
                })
                self.layoutIfNeeded()
            })
        }
    }
}

// MARK:- get the cgfloat of the color
extension TitleView {
    
    fileprivate func rgb(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        return (color.components[0] * 255, color.components[1] * 255, color.components[2] * 255)
    }
}


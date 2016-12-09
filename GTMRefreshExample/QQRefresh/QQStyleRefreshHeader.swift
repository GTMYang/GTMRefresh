//
//  QQStyleRefreshHeader.swift
//  GTMRefresh
//
//  Created by luoyang on 2016/12/8.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import UIKit
import GTMRefresh

class QQStyleRefreshHeader: GTMRefreshHeader, SubGTMRefreshHeaderProtocol {

    let control:QQStylePullingIndicator
    open let textLabel:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 120,height: 40))
    open let imageView:UIImageView = UIImageView(frame: CGRect.zero)
    
    // MARK: Life Cycle
    
    override public init(frame: CGRect) {
        control = QQStylePullingIndicator(frame: frame)
        super.init(frame: frame)
        
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = UIColor.white
        imageView.sizeToFit()
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.darkGray
        addSubview(control)
        addSubview(textLabel)
        addSubview(imageView)
        
//        textLabel.text = textDic[.pullToRefresh]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        control.frame = self.bounds
        
        let totalHegiht = self.contentHeight()
        imageView.center = CGPoint(x: frame.width/2 - 40 - 40, y: totalHegiht * 0.75)
        textLabel.center = CGPoint(x: frame.size.width/2, y: totalHegiht * 0.75);
    }
    
    // MARK: override
    
    /// Loadding动画显示区域的高度(特殊的控件需要重写该方法，返回不同的数值)
    ///
    /// - Returns: Loadding动画显示区域的高度
    public override func refreshingHoldHeight() -> CGFloat {
        return 40.0
    }
    
    
    // MARK: SubGTMRefreshHeaderProtocol
    func contentHeight() -> CGFloat {
        return 80.0
    }
    
    func toNormalState() {
        
        self.control.isHidden = false
        self.imageView.isHidden = true
        self.textLabel.isHidden = true
    }
    func toRefreshingState() {
        
        self.control.animating = true
    }
    func toPullingState() {
    }
    func changePullingPercent(percent: CGFloat) {
        
        self.control.animating = false
        if percent > 0.5 && percent <= 1.0{
            self.control.progress = (percent - 0.5)/0.5
        }else if percent <= 0.5{
            self.control.progress = 0.0
        }else{
            self.control.progress = 1.0
        }
    }
    func toWillRefreshState() {
    }
    
    func willBeginEndRefershing(isSuccess: Bool) {
        if isSuccess {
            self.control.isHidden = true
            imageView.isHidden = false
            textLabel.isHidden = false
            textLabel.text =  GTMRHeaderString.refreshSuccess
            imageView.image = UIImage(named: "success", in: Bundle(for: GTMRefreshHeader.self), compatibleWith: nil)
        } else {
            self.control.isHidden = true
            imageView.isHidden = false
            textLabel.isHidden = false
            textLabel.text = GTMRHeaderString.refreshFailure
            imageView.image = UIImage(named: "failure", in: Bundle(for: GTMRefreshHeader.self), compatibleWith: nil)
        }
    }
    func willCompleteEndRefershing() {
        
    }

}

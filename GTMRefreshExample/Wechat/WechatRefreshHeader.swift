//
//  WechatRefreshHeader.swift
//  GTMRefreshExample
//
//  Created by 骆扬 on 2020/1/2.
//  Copyright © 2020 luoyang. All rights reserved.
//

import GTMRefresh
import UIKit

class WechatRefreshHeader: GTMRefreshHeader, SubGTMRefreshHeaderProtocol {
    var wheel: UIImageView = {
        let wheel = UIImageView()
        wheel.image = UIImage(named: "wechat")
        
        return wheel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = .white
    }
    
    func startWheelAnimation() {
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(value: Double.pi * 2.0 as Double)
        rotateAnimation.duration = 1.6
        rotateAnimation.isCumulative = true
        rotateAnimation.repeatCount = MAXFLOAT
        self.wheel.layer.add(rotateAnimation, forKey: "rotate")
    }
    
    
    // MARK: - SubGTMRefreshHeaderProtocol
    /// 状态变成.idle
    func toNormalState() {
        self.wheel.removeFromSuperview()
    }
    
    /// 状态变成.pulling
    func toPullingState() {
        // 掉落动画
        if self.wheel.superview == nil {
            self.scrollView?.addSubview(self.wheel)
            self.wheel.frame = CGRect(x: 20, y: -30, width: 28, height: 28)
            UIView.animate(withDuration: 0.5) {
                self.wheel.frame = CGRect(x: 20, y: 30, width: 28, height: 28)
            }
        }
    }
    /// 状态变成.willRefresh
    func toRefreshingState() {
        if self.wheel.superview == nil {
            self.scrollView?.addSubview(self.wheel)
            self.wheel.frame = CGRect(x: 20, y: -30, width: 28, height: 28)
            UIView.animate(withDuration: 0.5) {
                self.wheel.frame = CGRect(x: 20, y: 30, width: 28, height: 28)
            }
        }
        startWheelAnimation()
    }
    /// 结束动画完成后执行
    func didEndRefreshing() {
        self.wheel.layer.removeAllAnimations()
    }
    
    func contentHeight() -> CGFloat {
        return 30
    }
    override func refreshingHoldHeight() -> CGFloat {
        return 10
    }
    
    
}

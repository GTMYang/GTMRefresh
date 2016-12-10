//
//  YoukuRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by luoyang on 2016/12/8.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import GTMRefresh
import UIKit

class YoukuRefreshHeader: GTMRefreshHeader, SubGTMRefreshHeaderProtocol {
    let iconImageView = UIImageView()// 这个ImageView用来显示下拉箭头
    let rotatingImageView = UIImageView() //这个ImageView用来播放动图
    let backgroundImageView = UIImageView() //这个ImageView用来显示广告的
    let frameHeight = UIScreen.main.bounds.size.width * 328.0/571.0

    override init(frame: CGRect) {
        
       // let adjustFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frameHeight)
        super.init(frame: frame)
        iconImageView.image = UIImage(named: "youku_down")
        rotatingImageView.image = UIImage(named: "youku_refreshing")
        backgroundImageView.image = UIImage(named: "youku_ad.jpeg")
        
        self.contentView.addSubview(backgroundImageView)
        self.contentView.addSubview(rotatingImageView)
        self.contentView.addSubview(iconImageView)
    }
//    override func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//        if let superView = newSuperview{
//            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: superView.frame.size.width, height: frameHeight)
//        }
//    }
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: frameHeight)
        iconImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
       // iconImageView.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
        iconImageView.center = CGPoint(x: self.contentView.bounds.width/2, y: self.contentView.bounds.height/2)
        
        rotatingImageView.frame = iconImageView.frame
        rotatingImageView.center = iconImageView.center
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func refreshingHoldHeight() -> CGFloat {
//        return 60.0
//    }
    
    
    func toNormalState() {
        UIView.animate(withDuration: 0.4, animations: {
            self.iconImageView.transform = CGAffineTransform.identity
        })
    }
    func toRefreshingState() {
        self.iconImageView.isHidden = true
        self.rotatingImageView.isHidden = false
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(value: M_PI * 2.0 as Double)
        rotateAnimation.duration = 0.8
        rotateAnimation.isCumulative = true
        rotateAnimation.repeatCount = 10000000
        self.rotatingImageView.layer.add(rotateAnimation, forKey: "rotate")
    }
    func toPullingState() {
        UIView.animate(withDuration: 0.4, animations: {
            self.iconImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI+0.000001))
        })
    }
    func toWillRefreshState() {
    }
    func changePullingPercent(percent: CGFloat) {
    }
    func willBeginEndRefershing(isSuccess: Bool) {
        self.rotatingImageView.isHidden = true
        self.iconImageView.isHidden = false
        self.iconImageView.layer.removeAllAnimations()
        self.iconImageView.layer.transform = CATransform3DIdentity
        self.iconImageView.image = UIImage(named: "youku_down")
    }
    func willCompleteEndRefershing() {
    }
    func contentHeight()->CGFloat{
        return 60
    }
    
}

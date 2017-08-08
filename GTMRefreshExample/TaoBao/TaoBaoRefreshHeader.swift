//
//  TaoBaoRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by luoyang on 2016/12/8.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import UIKit
import GTMRefresh


class TaoBaoRefreshHeader: GTMRefreshHeader, SubGTMRefreshHeaderProtocol {
    fileprivate let circleLayer = CAShapeLayer()
    fileprivate let arrowLayer = CAShapeLayer()
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 230, height: 35))
    fileprivate let textLabel = UILabel()
    fileprivate let strokeColor = UIColor(red: 135.0/255.0, green: 136.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCircleLayer()
        setUpArrowLayer()
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.lightGray
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.text = "下拉即可刷新..."
        imageView.image = UIImage(named: "taobaoLogo")
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(textLabel)
    }
    func setUpArrowLayer(){
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 20, y: 15))
        bezierPath.addLine(to: CGPoint(x: 20, y: 25))
        bezierPath.addLine(to: CGPoint(x: 25,y: 20))
        bezierPath.move(to: CGPoint(x: 20, y: 25))
        bezierPath.addLine(to: CGPoint(x: 15, y: 20))
        self.arrowLayer.path = bezierPath.cgPath
        self.arrowLayer.strokeColor = UIColor.lightGray.cgColor
        self.arrowLayer.fillColor = UIColor.clear.cgColor
        self.arrowLayer.lineWidth = 1.0
        self.arrowLayer.lineCap = kCALineCapRound
        self.arrowLayer.bounds = CGRect(x: 0, y: 0,width: 40, height: 40)
        self.arrowLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.arrowLayer)
    }
    func setUpCircleLayer(){
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20),
                                      radius: 12.0,
                                      startAngle:CGFloat(-Double.pi/2),
                                      endAngle: CGFloat(Double.pi * 3),
                                      clockwise: true)
        self.circleLayer.path = bezierPath.cgPath
        self.circleLayer.strokeColor = UIColor.lightGray.cgColor
        self.circleLayer.fillColor = UIColor.clear.cgColor
        self.circleLayer.strokeStart = 0.05
        self.circleLayer.strokeEnd = 0.05
        self.circleLayer.lineWidth = 1.0
        self.circleLayer.lineCap = kCALineCapRound
        self.circleLayer.bounds = CGRect(x: 0, y: 0,width: 40, height: 40)
        self.circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.circleLayer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = CGRect(x: 0,y: 0,width: 120, height: 40)
        //放置Views和Layer
        imageView.center = CGPoint(x: frame.width/2, y: frame.height - 60 - 18)
        textLabel.center = CGPoint(x: frame.width/2 + 20, y: frame.height - 30)
        
        self.arrowLayer.position = CGPoint(x: frame.width/2 - 60, y: frame.height - 30)
        self.circleLayer.position = CGPoint(x: frame.width/2 - 60, y: frame.height - 30)
    }
    
    
    
    
    func toNormalState() {}
    func toRefreshingState() {
        self.circleLayer.strokeEnd = 0.95
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(value: Double.pi * 2.0 as Double)
        rotateAnimation.duration = 0.6
        rotateAnimation.isCumulative = true
        rotateAnimation.repeatCount = 10000000
        self.circleLayer.add(rotateAnimation, forKey: "rotate")
        self.arrowLayer.isHidden = true
        textLabel.text = "刷新中..."
    }
    func toPullingState() {}
    func toWillRefreshState() {}
    func changePullingPercent(percent: CGFloat) {
        let adjustPercent = max(min(1.0, percent),0.0)
        if adjustPercent  == 1.0{
            textLabel.text = "释放即可刷新..."
        }else{
            textLabel.text = "下拉即可刷新..."
        }
        self.circleLayer.strokeEnd = 0.05 + 0.9 * adjustPercent
    }
    func willBeginEndRefershing(isSuccess: Bool) {
//        transitionWithOutAnimation {
//            self.circleLayer.strokeEnd = 0.05
//        };
    }
    func willCompleteEndRefershing() {
        transitionWithOutAnimation {
            self.circleLayer.strokeEnd = 0.05
        };
        self.circleLayer.removeAllAnimations()
        self.arrowLayer.isHidden = false
        textLabel.text = "下拉即可刷新"
    }
    func contentHeight()->CGFloat{
        return 60
    }
    
    /// MARK: Private
    func transitionWithOutAnimation(_ clousre:()->()){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        clousre()
        CATransaction.commit()
    }
}

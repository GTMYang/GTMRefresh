//
//  CurveRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/3.
//  Copyright © 2016年 Leo. All rights reserved.
//

import GTMRefresh
import UIKit

class CurveRefreshHeader: GTMRefreshHeader, SubGTMRefreshHeaderProtocol {
    let imageView = UIImageView()
    let bgColor = UIColor(red: 77.0/255.0, green: 184.0/255.0, blue: 255.0/255.0, alpha: 0.65)
    let totalHeight = UIScreen.main.bounds.size.height
    let maskLayer = CAShapeLayer()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let backgroundLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.image = UIImage(named: "arrow_downWhite")
        self.layer.addSublayer(backgroundLayer)
        backgroundLayer.backgroundColor = bgColor.cgColor
        backgroundLayer.mask = maskLayer
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(spinner)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        spinner.center = CGPoint(x: self.contentView.bounds.width/2.0, y: self.contentView.bounds.height - 30)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        imageView.center = CGPoint(x: self.contentView.bounds.width/2.0, y: self.contentView.bounds.height - 30)
        
        backgroundLayer.bounds = self.contentView.bounds
        backgroundLayer.position = CGPoint(x: self.contentView.bounds.width/2, y: self.contentView.bounds.height/2)
        
        maskLayer.bounds = self.contentView.bounds
        maskLayer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func toNormalState() {
        UIView.animate(withDuration: 0.4, animations: {
            self.imageView.transform = CGAffineTransform.identity
        })
    }
    func toRefreshingState() {
        spinner.startAnimating()
        let controPoint = CGPoint(x: self.bounds.width/2, y: self.bounds.height - 60.0)
        self.maskLayer.path = createLayerWithY(60, controlPoint: controPoint).cgPath
    }
    func toPullingState() {
        UIView.animate(withDuration: 0.4, animations: {
            self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI+0.000001))
        })
    }
    func toWillRefreshState() {
    }
    func changePullingPercent(percent: CGFloat) {
        let heightScrolled = 60 * percent;
        let adjustHeight = heightScrolled < 60 ? heightScrolled : 60;
        print(adjustHeight)
        let controlPoint = CGPoint(x: self.bounds.width/2, y: self.bounds.height + adjustHeight)
        let bezierPath = createLayerWithY(adjustHeight,controlPoint: controlPoint)
        self.maskLayer.path = bezierPath.cgPath
    }
    func willBeginEndRefershing(isSuccess: Bool) {
        spinner.stopAnimating()
        imageView.transform = CGAffineTransform.identity
        imageView.image = UIImage(named: "success")
    }
    func willCompleteEndRefershing() {
        imageView.image = UIImage(named: "arrow_downWhite")
    }
    func contentHeight()->CGFloat{
        return totalHeight
    }
    
    func createLayerWithY(_ y:CGFloat,controlPoint:CGPoint)->UIBezierPath{
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0));
        bezierPath.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        bezierPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height - y))
        bezierPath.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height - y), controlPoint: controlPoint)
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        return bezierPath
    }
    
    // MARK: - RefreshableHeader -
//    func heightForRefreshingState()->CGFloat{
//        return 60
//    }
}

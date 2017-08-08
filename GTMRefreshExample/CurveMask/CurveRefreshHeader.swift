//
//  CurveRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by luoyang on 2016/12/8.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import GTMRefresh
import UIKit

class CurveRefreshHeader: GTMRefreshHeader, SubGTMRefreshHeaderProtocol {
    
    let pullingIndicator = UIImageView()
   // let bgColor = UIColor(red: 77.0/255.0, green: 184.0/255.0, blue: 255.0/255.0, alpha: 0.65)
    let totalHeight = UIScreen.main.bounds.size.height
    let maskLayer = CAShapeLayer()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let backgroundLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pullingIndicator.image = UIImage(named: "arrow_downWhite")
        
        self.contentView.layer.addSublayer(backgroundLayer)
        backgroundLayer.backgroundColor = UIColor(red: 77.0/255.0, green: 184.0/255.0, blue: 255.0/255.0, alpha: 0.65).cgColor
        backgroundLayer.mask = maskLayer
        
        self.contentView.addSubview(pullingIndicator)
        self.contentView.addSubview(spinner)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: self.contentView.bounds.width/2, y: self.contentView.bounds.height - 30)
        spinner.center = center
        
        pullingIndicator.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        pullingIndicator.center = center
        
        backgroundLayer.bounds = self.contentView.bounds
        backgroundLayer.position = CGPoint(x: self.contentView.bounds.width/2, y: self.contentView.bounds.height/2)
        
        maskLayer.bounds = self.contentView.bounds
        maskLayer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshingHoldHeight() -> CGFloat {
        return 60
    }
    
    /// 即将触发刷新的高度(特殊的控件需要重写该方法，返回不同的数值)
    ///
    /// - Returns: 触发刷新的高度
    open override func willRefresHeight() -> CGFloat {
        return 60
    }
    
    
    
    func toNormalState() {
        UIView.animate(withDuration: 0.4, animations: {
            self.pullingIndicator.transform = CGAffineTransform.identity
        })
    }
    func toRefreshingState() {
        spinner.startAnimating()
        let controPoint = CGPoint(x: self.bounds.width/2, y: self.bounds.height - 60.0)
        self.maskLayer.path = createLayerWithY(60, controlPoint: controPoint).cgPath
    }
    func toPullingState() {
        UIView.animate(withDuration: 0.4, animations: {
            self.pullingIndicator.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi+0.000001))
        })
    }
  
    func changePullingPercent(percent: CGFloat) {
        let heightScrolled = 60 * percent;
        let adjustHeight = heightScrolled < 60 ? heightScrolled : 60;
      //  print(adjustHeight)
        let controlPoint = CGPoint(x: self.bounds.width/2, y: self.bounds.height + adjustHeight)
        let bezierPath = createLayerWithY(adjustHeight,controlPoint: controlPoint)
        self.maskLayer.path = bezierPath.cgPath
    }
    func willBeginEndRefershing(isSuccess: Bool) {
        spinner.stopAnimating()
        pullingIndicator.transform = CGAffineTransform.identity
      //  imageView.image = UIImage(named: "success")
    }
    func willCompleteEndRefershing() {
        pullingIndicator.image = UIImage(named: "arrow_downWhite")
    }
    func contentHeight()->CGFloat{
        return 500
    }
    
    // MARK: Private
    func createLayerWithY(_ y:CGFloat,controlPoint:CGPoint)->UIBezierPath{
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0));
        bezierPath.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        bezierPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height - y))
        bezierPath.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height - y), controlPoint: controlPoint)
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        return bezierPath
    }
    
}

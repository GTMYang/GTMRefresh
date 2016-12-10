//
//  QQVideoRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by luoyang on 2016/12/8.
//  Copyright © 2016年 luoyang. All rights reserved.
//
import GTMRefresh
import UIKit

class QQVideoRefreshHeader: GTMRefreshHeader, SubGTMRefreshHeaderProtocol {
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.image = UIImage(named: "loading15")
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: 27, height: 10)
        imageView.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
    }
    
    
    
    func toNormalState() {
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.transform = CGAffineTransform(translationX: 0, y: -50)
        })
    }
    func toRefreshingState() {
        imageView.image = nil
        let images = (0...29).map{return $0 < 10 ? "loading0\($0)" : "loading\($0)"}
        imageView.animationImages = images.map{return UIImage(named:$0)!}
        imageView.animationDuration = Double(images.count) * 0.04
        imageView.startAnimating()
    }
    func toPullingState() {
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.transform = CGAffineTransform.identity
        })
    }
    func toWillRefreshState() {}
    func changePullingPercent(percent: CGFloat) {}
    func willBeginEndRefershing(isSuccess: Bool) {}
    func willCompleteEndRefershing() {
        imageView.animationImages = nil
        imageView.stopAnimating()
        imageView.image = UIImage(named: "loading15")
    }
    func contentHeight() -> CGFloat {
        return 50
    }
    
  
}

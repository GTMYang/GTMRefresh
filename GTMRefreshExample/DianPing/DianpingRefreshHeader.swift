//
//  DianpingRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by luoyang on 2016/12/8.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import GTMRefresh
import UIKit

class DianpingRefreshHeader: GTMRefreshHeader, SubGTMRefreshHeaderProtocol {
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imageView.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
    }
    
    
    
    func toNormalState() {}
    func toRefreshingState() {
        let images = ["dropdown_loading_01","dropdown_loading_02","dropdown_loading_03"].map { (name) -> UIImage in
            return UIImage(named:name)!
        }
        imageView.animationImages = images
        imageView.animationDuration = Double(images.count) * 0.15
        imageView.startAnimating()
    }
    func toPullingState() {}
    func toWillRefreshState() {}
    func changePullingPercent(percent: CGFloat) {
        imageView.isHidden = (percent == 0)
        let adjustPercent = max(min(1.0, percent),0.0)
        let scale = 0.2 + (1.0 - 0.2) * adjustPercent;
        imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        let mappedIndex = Int(adjustPercent * 60)
        let imageName = "dropdown_anim__000\(mappedIndex)"
        let image = UIImage(named: imageName)
        imageView.image = image
    }
    func willBeginEndRefershing(isSuccess: Bool) {}
    func willCompleteEndRefershing() {
        imageView.animationImages = nil
        imageView.stopAnimating()
        imageView.isHidden = true
    }
    func contentHeight()->CGFloat{
        return 70
    }
}

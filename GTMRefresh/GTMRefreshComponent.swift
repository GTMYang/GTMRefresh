//
//  GTMRefreshComponent.swift
//  GTMRefresh
//
//  Created by luoyang on 2016/12/7.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import UIKit

/// 状态枚举
///
/// - idle:         闲置
/// - pulling:      可以进行刷新
/// - refreshing:   正在刷新
/// - willRefresh:  即将刷新
/// - noMoreData:   没有更多数据
public enum GTMRefreshState {
    case idle
    case pulling
    case refreshing
    case willRefresh
    case noMoreData
}

public protocol SubGTMRefreshComponentProtocol {
    func scollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?)
    func scollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?)
}

open class GTMRefreshComponent: UIView {
    
    public var scrollView: UIScrollView?
    
    public var scrollViewOriginalInset: UIEdgeInsets?
    
    var state: GTMRefreshState = .idle
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.backgroundColor = UIColor.clear
        
        self.state = .idle
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.state == .willRefresh {
            // 预防view还没显示出来就调用了beginRefreshing
            self.state = .refreshing
        }
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard newSuperview is UIScrollView else {
            return
        }
        
        self.removeAbserver()
        
        guard let superView = newSuperview else {
            return
        }
        
        self.mj_w = superView.mj_w
        self.mj_x = 0
        
        self.scrollView = newSuperview as! UIScrollView?
        // 设置永远支持垂直弹簧效果
        self.scrollView?.alwaysBounceVertical = true
        self.scrollViewOriginalInset = self.scrollView?.mj_inset
        
        self.addObserver()
    }
    
    
    // MARK: KVO
    
    private func addObserver() {
        scrollView?.addObserver(self, forKeyPath: GTMRefreshConstant.keyPathContentOffset, options: .new, context: nil)
        scrollView?.addObserver(self, forKeyPath: GTMRefreshConstant.keyPathContentSize, options: .new, context: nil)
    }
    
    private func removeAbserver() {
        scrollView?.removeObserver(self, forKeyPath: GTMRefreshConstant.keyPathContentOffset)
        scrollView?.removeObserver(self, forKeyPath: GTMRefreshConstant.keyPathContentSize)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard isUserInteractionEnabled else {
            return
        }
        
        if let sub: SubGTMRefreshComponentProtocol = self as? SubGTMRefreshComponentProtocol {
            if keyPath == GTMRefreshConstant.keyPathContentSize {
                sub.scollViewContentSizeDidChange(change: change)
            }
            
            guard !self.isHidden else {
                return
            }
            
            if keyPath == GTMRefreshConstant.keyPathContentOffset {
                sub.scollViewContentOffsetDidChange(change: change)
            }
            
        }
    }
    
    
    
}

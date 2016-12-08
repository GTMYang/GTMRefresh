//
//  GTMRefreshHeader.swift
//  GTMRefresh
//
//  Created by luoyang on 2016/12/7.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import UIKit

public protocol SubGTMRefreshHeaderProtocol {
    func headerToNormalState()
    func headerToRefreshingState()
    func headerToPullingState()
    func headerSet(pullingPercent: CGFloat)
    func headerToWillRefreshState()
}

public class GTMRefreshHeader: GTMRefreshComponent, SubGTMRefreshComponentProtocol {
    
    /// 刷新数据Block
    var refreshBlock: () -> Void = {}
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var originScollViewInsetT: CGFloat = 0
    
    var pullingPercent: CGFloat = 0 {
        didSet {
            let sub: SubGTMRefreshHeaderProtocol? = self as? SubGTMRefreshHeaderProtocol
            sub?.headerSet(pullingPercent: pullingPercent)
        }
    }
    
    override var state: GTMRefreshState {
        // FIXME: get方法可能死循环，需要测试
        get { return self.state }
        set {
            guard state != newValue else {
                return
            }
            
            let sub: SubGTMRefreshHeaderProtocol? = self as? SubGTMRefreshHeaderProtocol
            switch newValue {
            case .idle:
                guard state == GTMRefreshState.refreshing else {
                    return
                }
                // 恢复Inset
                UIView.animate(withDuration: GTMRefreshConstant.slowAnimationDuration, animations: {
                    self.scrollView?.mj_insetT = self.originScollViewInsetT
                    sub?.headerToNormalState()
                })
            case .pulling:
                DispatchQueue.main.async {
                    sub?.headerToPullingState()
                }
            case .willRefresh:
                DispatchQueue.main.async {
                    sub?.headerToWillRefreshState()
                }
            case .refreshing:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: GTMRefreshConstant.fastAnimationDuration, animations: {
                        guard let originInset = self.scrollViewOriginalInset else {
                            return
                        }
                        let top: CGFloat = originInset.top + self.mj_h
                        // 增加滚动区域top
                        self.scrollView?.mj_insetT = top
                        // 设置滚动位置
                        self.scrollView?.contentOffset = CGPoint(x: 0, y: -top)
                    })
                    sub?.headerToRefreshingState()
                }
            default: break
            }
        }
    }

    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.contentView)
        self.contentView.autoresizingMask = UIViewAutoresizing.flexibleWidth
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.frame = self.bounds
    }
    
    // MARK: SubGTMRefreshComponentProtocol
    open func scollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
        guard let scrollV = self.scrollView, let originalInset = self.scrollViewOriginalInset else {
            return
        }
        
        if state == .refreshing {
            
            // FIXME: need debug
            guard let _ = self.window else {
                return
            }
            // 考虑SectionHeader停留时的高度
            var insetT: CGFloat = -scrollV.mj_offsetY > originalInset.top ? -scrollV.mj_offsetY : originalInset.top;
            insetT = insetT > self.mj_h + originalInset.top ? self.mj_h + originalInset.top : insetT;
            
            scrollV.mj_insetT = insetT;
            self.originScollViewInsetT = originalInset.top - insetT;
            
            return;
        }
        // 跳转到下一个控制器时，contentInset可能会变
        self.scrollViewOriginalInset = scrollV.contentInset
        
        // 当前的contentOffset
        let offsetY: CGFloat = scrollV.mj_offsetY;
        // 头部控件刚好出现的offsetY
        let happenOffsetY: CGFloat = -originalInset.top;
        
        // 如果是向上滚动到看不见头部控件，直接返回
        guard offsetY <= happenOffsetY else {
            return
        }
        
        // 普通 和 即将刷新 的临界点
        let idle2pullingOffsetY: CGFloat = happenOffsetY - self.mj_h;
        
        if scrollV.isDragging {
            switch state {
            case .idle:
                if offsetY < idle2pullingOffsetY {
                    state = .pulling
                }
            case .pulling:
                if offsetY >= idle2pullingOffsetY {
                    state = .willRefresh
                } else {
                    self.pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
                }
            default: break
            }
        } else {
            // 停止Drag && 并且是即将刷新状态
            if state == .willRefresh {
                // 开始刷新
                self.pullingPercent = 1.0;
                // 只要正在刷新，就完全显示
                if self.window != nil {
                    state = .refreshing
                } else {
                    // 预防正在刷新中时，调用本方法使得header inset回置失败
                    if state != .refreshing {
                        state = .willRefresh
                        // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                        self.setNeedsDisplay()
                    }
                }
            }
        }
    }
    open func scollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
    }
    open func scollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
    }
    
    // MARK: Public
    
    /// 结束刷新
    final public func endRefresing() {
        DispatchQueue.main.async {
           self.state = .idle
        }
    }
    
}

class DefaultGTMRefreshHeader: GTMRefreshHeader {
    
}

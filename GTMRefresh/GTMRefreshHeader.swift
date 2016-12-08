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
    func headerToWillRefreshState()
    func headerSet(pullingPercent: CGFloat)
    func willBeginEndRefershing(isSuccess: Bool)
}

open class GTMRefreshHeader: GTMRefreshComponent, SubGTMRefreshComponentProtocol {
    
    /// 刷新数据Block
    var refreshBlock: () -> Void = { print("refreshBlock") }
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var insetTDelta: CGFloat = 0
    
    var pullingPercent: CGFloat = 0 {
        didSet {
            let sub: SubGTMRefreshHeaderProtocol? = self as? SubGTMRefreshHeaderProtocol
            sub?.headerSet(pullingPercent: pullingPercent)
        }
    }
    
    override var state: GTMRefreshState {
        // FIXME: get方法可能死循环，需要测试
        //get { return self.state }
        didSet {
            guard oldValue != state else {
                return
            }
            
            let sub: SubGTMRefreshHeaderProtocol? = self as? SubGTMRefreshHeaderProtocol
            switch state {
            case .idle:
                guard oldValue == GTMRefreshState.refreshing else {
                    return
                }
                // 恢复Inset
                UIView.animate(withDuration: GTMRefreshConstant.slowAnimationDuration, animations: {
                    self.scrollView?.mj_insetT += self.insetTDelta
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
                    }, completion: { (isFinish) in
                        sub?.headerToRefreshingState()
                        // 执行刷新操作
                        self.refreshBlock()
                    })
                }
            default: break
            }
        }
    }

    // MARK: Life Cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.contentView)
        self.contentView.autoresizingMask = UIViewAutoresizing.flexibleWidth
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // change frame
        var f = frame
        f.origin.y = -frame.size.height
        self.frame = f
        print("f.origin.y = \(f.origin.y) frame.size.height = \(frame.size.height)")
        
        self.contentView.frame = self.bounds
    }
    
    // MARK: SubGTMRefreshComponentProtocol
    open func scollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
        guard let scrollV = self.scrollView else {
            return
        }
        
        let originalInset = self.scrollViewOriginalInset!
        
        if state == .refreshing {
            
            // FIXME: need debug
            guard let _ = self.window else {
                return
            }
            // 考虑SectionHeader停留时的高度
            var insetT: CGFloat = -scrollV.mj_offsetY > originalInset.top ? -scrollV.mj_offsetY : originalInset.top;
            insetT = insetT > self.mj_h + originalInset.top ? self.mj_h + originalInset.top : insetT;
            
            scrollV.mj_insetT = insetT;
            self.insetTDelta = originalInset.top - insetT;
            
            return;
        }
        // 跳转到下一个控制器时，contentInset可能会变
        self.scrollViewOriginalInset = scrollV.contentInset
        
        // 当前的contentOffset
        let offsetY: CGFloat = scrollV.mj_offsetY;
        // 头部控件刚好出现的offsetY
        let headerInOffsetY: CGFloat = -originalInset.top;
        
        // 如果是向上滚动头部控件还没出现，直接返回
        guard offsetY <= headerInOffsetY else {
            return
        }
        
        // 普通 和 即将刷新 的临界点
        let idle2pullingOffsetY: CGFloat = headerInOffsetY - self.mj_h;
        
        if scrollV.isDragging {
            switch state {
            case .idle:
                if offsetY <= headerInOffsetY {
                    state = .pulling
                }
            case .pulling:
               // print("offsetY = \(offsetY)  idle2pullingOffsetY = \(idle2pullingOffsetY)")
                if offsetY <= idle2pullingOffsetY {
                    state = .willRefresh
                } else {
                    self.pullingPercent = (headerInOffsetY - offsetY) / self.mj_h;
//                    print("headerInOffsetY = \(headerInOffsetY)  idle2pullingOffsetY = \(idle2pullingOffsetY)  offsetY = \(offsetY)  pullingPercent = \(pullingPercent)")
                }
            case .willRefresh:
                if offsetY > idle2pullingOffsetY {
                    state = .idle
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
    final public func endRefresing(isSuccess: Bool) {
        let sub: SubGTMRefreshHeaderProtocol? = self as? SubGTMRefreshHeaderProtocol
        sub?.willBeginEndRefershing(isSuccess: isSuccess)
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.state = .idle
        }
    }
    
}

class DefaultGTMRefreshHeader: GTMRefreshHeader, SubGTMRefreshHeaderProtocol {
    
    lazy var pullingIndicator: UIImageView = {
        let pindicator = UIImageView()
        pindicator.image = UIImage(named: "arrow_down", in: Bundle(for: DefaultGTMRefreshHeader.self), compatibleWith: nil)
        
        return pindicator
    }()
    
    lazy var loaddingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        indicator.backgroundColor = UIColor.white
        
        return indicator
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.messageLabel)
        self.contentView.addSubview(self.pullingIndicator)
        self.contentView.addSubview(self.loaddingIndicator)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: frame.width * 0.5 - 70 - 20, y: frame.height * 0.5)
        pullingIndicator.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        pullingIndicator.mj_center = center
        
        loaddingIndicator.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        loaddingIndicator.mj_center = center
        messageLabel.frame = self.bounds
    }
    
    // MARK: SubGTMRefreshHeaderProtocol
    
    func headerToNormalState() {
        print("-------> headerToNormalState() ")
        self.loaddingIndicator.isHidden = true
        self.loaddingIndicator.stopAnimating()
        
        messageLabel.text =  GTMRHeaderString.pullDownToRefresh
        pullingIndicator.image = UIImage(named: "arrow_down", in: Bundle(for: DefaultGTMRefreshHeader.self), compatibleWith: nil)
    }
    func headerToRefreshingState() {
        print("-------> headerToRefreshingState() ")
        self.loaddingIndicator.isHidden = false
        self.loaddingIndicator.startAnimating()
        messageLabel.text = GTMRHeaderString.refreshing
    }
    func headerToPullingState() {
        print("-------> headerToPullingState() ")
        self.loaddingIndicator.isHidden = true
        messageLabel.text = GTMRHeaderString.pullDownToRefresh
        
        guard pullingIndicator.transform == CGAffineTransform(rotationAngle: CGFloat(-M_PI+0.000001))  else{
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.pullingIndicator.transform = CGAffineTransform.identity
        })
    }
    func headerToWillRefreshState() {
        print("-------> headerToWillRefreshState() ")
        messageLabel.text = GTMRHeaderString.releaseToRefresh
        self.loaddingIndicator.isHidden = true
        
        guard pullingIndicator.transform == CGAffineTransform.identity else{
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.pullingIndicator.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI+0.000001))
        })
    }
    func headerSet(pullingPercent: CGFloat) {
//        let angle = CGFloat(-M_PI) * pullingPercent + 0.000001
//        pullingIndicator.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    func willBeginEndRefershing(isSuccess: Bool) {
        self.pullingIndicator.transform = CGAffineTransform.identity
        self.loaddingIndicator.isHidden = true
        
        if isSuccess {
            messageLabel.text =  GTMRHeaderString.refreshSuccess
            pullingIndicator.image = UIImage(named: "success", in: Bundle(for: DefaultGTMRefreshHeader.self), compatibleWith: nil)
        } else {
            messageLabel.text =  GTMRHeaderString.refreshFailure
            pullingIndicator.image = UIImage(named: "failure", in: Bundle(for: DefaultGTMRefreshHeader.self), compatibleWith: nil)
        }
        
    }
}

class WaterIndicator: UIView {
    let maxRadius: CGFloat = 15.0
    
    /// 指示器进度
    var progress: CGFloat {
        get { return self.progress }
        set {
            if progress != newValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
//        let tCircleRadis = maxRadius
//        let bCircleRadis = maxRadius * (1 - progress)
    }
    
}










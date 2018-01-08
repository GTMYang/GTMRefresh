//
//  GTMRefreshHeader.swift
//  GTMRefresh
//
//  Created by luoyang on 2016/12/7.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import UIKit

@objc public protocol SubGTMRefreshHeaderProtocol {
    /// 状态变成.idle
    @objc optional func toNormalState()
    /// 状态变成.refreshing
    @objc optional func toRefreshingState()
    /// 状态变成.pulling
    @objc optional func toPullingState()
    /// 状态变成.willRefresh
    @objc optional func toWillRefreshState()
    /// 下拉高度／触发高度 值改变
    @objc optional func changePullingPercent(percent: CGFloat)
    /// 开始结束动画前执行
    @objc optional func willBeginEndRefershing(isSuccess: Bool)
    /// 结束动画完成后执行
    @objc optional func willCompleteEndRefershing()
    
    /// 控件的高度
    ///
    /// - Returns: 控件的高度
    func contentHeight() -> CGFloat
}

open class GTMRefreshHeader: GTMRefreshComponent, SubGTMRefreshComponentProtocol {
    
    /// 刷新数据Block
    var refreshBlock: () -> Void = { }
    
    public var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var insetTDelta: CGFloat = 0
    
    public var subProtocol: SubGTMRefreshHeaderProtocol? {
        get { return self as? SubGTMRefreshHeaderProtocol }
    }
    
    var pullingPercent: CGFloat = 0 {
        didSet {
            subProtocol?.changePullingPercent?(percent: pullingPercent)
        }
    }
    
    override var state: GTMRefreshState {
        didSet {
            guard oldValue != state else {
                return
            }
            
            switch state {
            case .idle:
                guard oldValue == GTMRefreshState.refreshing else {
                    return
                }
                // 恢复Inset
                UIView.animate(withDuration: GTMRefreshConstant.slowAnimationDuration, animations: {
                    self.scrollView?.mj_insetT += self.insetTDelta
                }, completion: { (isFinish) in
                    self.subProtocol?.willCompleteEndRefershing?()
                    // 执行刷新操作
                    self.subProtocol?.toNormalState?()
                })
            case .pulling:
                DispatchQueue.main.async {
                    self.subProtocol?.toPullingState?()
                }
            case .willRefresh:
                DispatchQueue.main.async {
                    self.subProtocol?.toWillRefreshState?()
                }
            case .refreshing:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: GTMRefreshConstant.fastAnimationDuration, animations: {
                        self.subProtocol?.toRefreshingState?()
                        
                        guard let originInset = self.scrollViewOriginalInset else {
                            return
                        }
                        let top: CGFloat = originInset.top + self.refreshingHoldHeight()
                        // 增加滚动区域top
                        self.scrollView?.mj_insetT = top
                        // 设置滚动位置
                        self.scrollView?.contentOffset = CGPoint(x: 0, y: -top)
                    }, completion: { (isFinish) in
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
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard newSuperview != nil else {
            // newSuperview == nil 被移除的时候
            return
        }
        
        // newSuperview != nil 被添加到新的View上
        self.mj_y = -self.mj_h
    }
    
    // MARK: Layout
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.frame = self.bounds
    }
    
    /// Loadding动画显示区域的高度(特殊的控件需要重写该方法，返回不同的数值)
    ///
    /// - Returns: Loadding动画显示区域的高度
    open func refreshingHoldHeight() -> CGFloat {
        return self.mj_h // 默认使用控件高度
    }
    
    /// 即将触发刷新的高度(特殊的控件需要重写该方法，返回不同的数值)
    ///
    /// - Returns: 触发刷新的高度
    open func willRefresHeight() -> CGFloat {
        return self.mj_h // 默认使用控件高度
    }
    
    // MARK: SubGTMRefreshComponentProtocol
    open func scollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        
        guard let scrollV = self.scrollView else {
            return
        }
        
        let originalInset = self.scrollViewOriginalInset!
        
        if state == .refreshing {
            guard let _ = self.window else {
                return
            }
            // 考虑SectionHeader停留时的高度
            var insetT: CGFloat = (-scrollV.mj_offsetY > originalInset.top) ? -scrollV.mj_offsetY : originalInset.top
            insetT = (insetT > self.refreshingHoldHeight() + originalInset.top) ? (self.refreshingHoldHeight() + originalInset.top) : insetT
            
            scrollV.mj_insetT = insetT
            self.insetTDelta = originalInset.top - insetT
            
            return
        }
        // 跳转到下一个控制器时，contentInset可能会变
        self.scrollViewOriginalInset = scrollV.mj_inset
        
        // 当前的contentOffset
        let offsetY: CGFloat = scrollV.mj_offsetY
        // 头部控件刚好出现的offsetY
        let headerInOffsetY: CGFloat = -originalInset.top
        
        // 如果是向上滚动头部控件还没出现，直接返回
        guard offsetY <= headerInOffsetY else {
            return
        }
        
        // 普通 和 即将刷新 的临界点
        let idle2pullingOffsetY: CGFloat = headerInOffsetY - self.willRefresHeight()
        
        if scrollV.isDragging {
            switch state {
            case .idle:
                if offsetY <= headerInOffsetY {
                    state = .pulling
                }
            case .pulling:
                if offsetY <= idle2pullingOffsetY {
                    state = .willRefresh
                } else {
                    self.pullingPercent = (headerInOffsetY - offsetY) / self.willRefresHeight()
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
                self.pullingPercent = 1.0
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
    open func scollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        // here do nothing
    }
    
    // MARK: Public API
    
    final public func autoRefreshing(){
        DispatchQueue.main.async {
            if self.window != nil {
                self.state = .refreshing
            }else{
                if self.state != .refreshing{
                    self.state = .willRefresh
                }
            }
        }
    }
    
    /// 结束刷新
    final public func endRefresing(isSuccess: Bool) {
        DispatchQueue.main.async {
            self.subProtocol?.willBeginEndRefershing?(isSuccess: isSuccess)
            self.state = .idle
        }
    }
    
}

public class DefaultGTMRefreshHeader: GTMRefreshHeader, SubGTMRefreshHeaderProtocol {
    
    var pullDownToRefresh = GTMRLocalize("pullDownToRefresh")
    var releaseToRefresh = GTMRLocalize("releaseToRefresh")
    var refreshSuccess = GTMRLocalize("refreshSuccess")
    var refreshFailure = GTMRLocalize("refreshFailure")
    var refreshing = GTMRLocalize("refreshing")
    
    var txtColor: UIColor? {
        didSet {
            if let color = txtColor {
                self.messageLabel.textColor = color
            }
        }
    }
    var idleImage: UIImage? {
        didSet {
            if let idleImg = idleImage {
                self.pullingIndicator.image = idleImg
            }
        }
    }
    var sucImage: UIImage?
    var failImage: UIImage?
    
    lazy var pullingIndicator: UIImageView = {
        let pindicator = UIImageView()
        pindicator.image = UIImage(named: "arrow_down", in: Bundle(for: GTMRefreshHeader.self), compatibleWith: nil)
        
        return pindicator
    }()
    
    lazy var loaddingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        //indicator.backgroundColor = UIColor.white
        
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: frame.width * 0.5 - 70 - 20, y: frame.height * 0.5)
        pullingIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        pullingIndicator.mj_center = center
        
        loaddingIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        loaddingIndicator.mj_center = center
        messageLabel.frame = self.bounds
    }
    
    // MARK: SubGTMRefreshHeaderProtocol
    
    /// 控件的高度
    ///
    /// - Returns: 控件的高度
    public func contentHeight() -> CGFloat {
        return 60.0
    }
    
    public func toNormalState() {
        self.loaddingIndicator.isHidden = true
        self.pullingIndicator.isHidden = false
        self.loaddingIndicator.stopAnimating()
        
        messageLabel.text =  self.pullDownToRefresh
        if let img = self.idleImage {
            pullingIndicator.image = img
        } else {
            pullingIndicator.image = UIImage(named: "arrow_down", in: Bundle(for: DefaultGTMRefreshHeader.self), compatibleWith: nil)
        }
    }
    public func toRefreshingState() {
        self.pullingIndicator.isHidden = true
        self.loaddingIndicator.isHidden = false
        self.loaddingIndicator.startAnimating()
        messageLabel.text = self.refreshing
    }
    public func toPullingState() {
        self.loaddingIndicator.isHidden = true
        messageLabel.text = self.pullDownToRefresh
        
        guard pullingIndicator.transform == CGAffineTransform(rotationAngle: CGFloat(-Double.pi+0.000001))  else{
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.pullingIndicator.transform = CGAffineTransform.identity
        })
    }
    public func toWillRefreshState() {
        messageLabel.text = self.releaseToRefresh
        self.loaddingIndicator.isHidden = true
        
        guard pullingIndicator.transform == CGAffineTransform.identity else{
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.pullingIndicator.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi+0.000001))
        })
    }
    public func changePullingPercent(percent: CGFloat) {
        // here do nothing
    }
    
    public func willBeginEndRefershing(isSuccess: Bool) {
        self.pullingIndicator.isHidden = false
        self.pullingIndicator.transform = CGAffineTransform.identity
        self.loaddingIndicator.isHidden = true
        
        if isSuccess {
            messageLabel.text =  self.refreshSuccess
            if let img = self.sucImage {
                pullingIndicator.image = img
            } else {
                pullingIndicator.image = UIImage(named: "success", in: Bundle(for: DefaultGTMRefreshHeader.self), compatibleWith: nil)
            }
        } else {
            messageLabel.text =  self.refreshFailure
            if let img = self.failImage {
                pullingIndicator.image = img
            } else {
                pullingIndicator.image = UIImage(named: "failure", in: Bundle(for: DefaultGTMRefreshHeader.self), compatibleWith: nil)
            }
        }
    }
    public func willCompleteEndRefershing() {
        
    }
}

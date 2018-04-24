//
//  GTMRefreshFooter.swift
//  GTMRefresh
//
//  Created by luoyang on 2016/12/7.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import UIKit

@objc public protocol SubGTMLoadMoreFooterProtocol {
    @objc optional func toNormalState()
    @objc optional func toNoMoreDataState()
    @objc optional func toWillRefreshState()
    @objc optional func toRefreshingState()
    
    /// 控件的高度(自定义控件通过该方法设置自定义高度)
    ///
    /// - Returns: 控件的高度
    func contentHeith() -> CGFloat
}

open class GTMLoadMoreFooter: GTMRefreshComponent, SubGTMRefreshComponentProtocol {
    
    /// 加载更多Block
    var loadMoreBlock: () -> Void = {}
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var lastBottomDelta: CGFloat = 0.0
    
    public var subProtocol: SubGTMLoadMoreFooterProtocol? {
        get { return self as? SubGTMLoadMoreFooterProtocol }
    }
    
    public var isNoMoreData: Bool = false {
        didSet {
            if isNoMoreData {
                state = .noMoreData
            } else {
                state = .idle
            }
        }
    }
    
    override var state: GTMRefreshState {
        didSet {
            guard oldValue != state, let scrollV = scrollView else {
                return
            }
            switch state {
            case .idle:
                // 结束加载
                UIView.animate(withDuration: GTMRefreshConstant.slowAnimationDuration, animations: {
                    scrollV.mj_insetB = self.lastBottomDelta
                  //  print("self.lastBottomDelta = \(self.lastBottomDelta)")
                }, completion: { (isComplet) in
                    self.subProtocol?.toNormalState?()
                })
            case .noMoreData:
                self.subProtocol?.toNoMoreDataState?()
            case .refreshing:
                self.loadMoreBlock()
                // 展示正在加载动效
                UIView.animate(withDuration: GTMRefreshConstant.fastAnimationDuration, animations: {
                    let overflowHeight = self.contentOverflowHeight
                    var toInsetB = self.mj_h + (self.scrollViewOriginalInset?.bottom)!
                    if overflowHeight < 0 {
                        // 如果内容还没占满
                        toInsetB -= overflowHeight
                    }
                    
                  //  self.lastBottomDelta = toInsetB - scrollV.mj_insetB
                    scrollV.mj_insetB = toInsetB
                    scrollV.mj_offsetY = self.footerCloseOffsetY + self.mj_h
                }, completion: { (isComplet) in
                })
                self.subProtocol?.toRefreshingState?()
                
            case .willRefresh:
                self.subProtocol?.toWillRefreshState?()
                
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
        
        self.scollViewContentSizeDidChange(change: nil)
        
    }
    
    // MARK: Layout
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.frame = self.bounds
    }
    
    
    // MARK: SubGTMRefreshComponentProtocol
    
    open func scollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        // refreshing或者noMoreData状态，直接返回
        guard state != .refreshing, state != .noMoreData, let scrollV = scrollView else {
            return
        }
        
        self.scrollViewOriginalInset = scrollV.mj_inset
        
        let currentOffsetY = scrollV.mj_offsetY
        let footerCloseOffsetY = self.footerCloseOffsetY
        
        
        guard currentOffsetY >= footerCloseOffsetY else {
            // footer还没出现， 直接返回
            return
        }
        
        if scrollV.isDragging {
            // 拖动状态
            let willLoadMoreOffsetY = footerCloseOffsetY + self.mj_h
          //  print("footerCloseOffsetY = \(footerCloseOffsetY)  footerH = \(self.mj_h)")
            
            switch currentOffsetY {
            case footerCloseOffsetY...willLoadMoreOffsetY:
                state = .pulling
            case willLoadMoreOffsetY...(willLoadMoreOffsetY + 1000):
                state = .willRefresh
            default: break
            }
        } else {
            // 停止拖动状态
            switch state {
            case .pulling:
                state = .idle
            case .willRefresh:
                state = .refreshing
            default: break
            }
        }
    }
    open func scollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        // here do nothing
        guard let scrollV = scrollView, let originInset = scrollViewOriginalInset else {
            return
        }
        // 重设位置
        let contentH = scrollV.mj_contentH  // 内容高度
        let visibleH = scrollV.mj_h - originInset.top - originInset.bottom  // 可见区域高度
        
        self.mj_y = contentH > visibleH ? contentH : visibleH
    }
    
    // MARK: Public
    public func endLoadMore(isNoMoreData: Bool) {
        if isNoMoreData {
            state = .noMoreData
        } else {
            state = .idle
        }
    }
    
    // MARK: Private
    
    /// ScrollView内容溢出的高度
    private var contentOverflowHeight: CGFloat {
        get {
            guard let scrollV = scrollView, let originInset = scrollViewOriginalInset else {
                return 0.0
            }
            // ScrollView内容占满的高度
            let fullContentHeight = scrollV.mj_h - originInset.bottom - originInset.top
            return scrollV.mj_contentH - fullContentHeight
        }
    }
    /// 上拉刷新控件即将出现时的OffsetY
    private var footerCloseOffsetY: CGFloat {
        get {
            guard let _ = scrollView, let originInset = scrollViewOriginalInset else {
                return 0.0
            }
            let overflowHeight = contentOverflowHeight
            if overflowHeight > 0 {
                return overflowHeight - originInset.top
            } else {
                return -originInset.top
            }
        }
    }
    
}



public class DefaultGTMLoadMoreFooter: GTMLoadMoreFooter, SubGTMLoadMoreFooterProtocol {
    
    var pullUpToRefreshText: String = GTMRLocalize("pullUpToRefresh")
    public var loaddingText: String = GTMRLocalize("loadMore")
    public var noMoreDataText: String = GTMRLocalize("noMoreData")
    public var releaseLoadMoreText: String = GTMRLocalize("releaseLoadMore")
    
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
    
    
    lazy var pullingIndicator: UIImageView = {
        let pindicator = UIImageView()
        if let img = self.idleImage {
            pindicator.image = img
        } else {
            pindicator.image = UIImage(named: "arrow_down", in: Bundle(for: GTMLoadMoreFooter.self), compatibleWith: nil)
        }
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
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard newSuperview != nil else {
            return
        }
        
        self.pullingIndicator.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi+0.000001))
    }
    
    // MARK: Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: frame.width * 0.5 - 70 - 30, y: frame.height * 0.5)
        pullingIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        pullingIndicator.mj_center = center
        
        loaddingIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        loaddingIndicator.mj_center = center
        messageLabel.frame = self.bounds
    }
    
    // MARK: SubGTMLoadMoreFooterProtocol
    
    /// 控件的高度
    ///
    /// - Returns: 控件的高度
    public func contentHeith() -> CGFloat {
        return 50.0
    }
    
    public func toNormalState() {
        self.pullingIndicator.isHidden = false
        self.loaddingIndicator.isHidden = true
        self.loaddingIndicator.stopAnimating()
        
        self.messageLabel.text =  self.pullUpToRefreshText
      //  print(".........\(self.messageLabel.text ?? "")")
        UIView.animate(withDuration: 0.4, animations: {
            self.pullingIndicator.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi+0.000001))
        })
    }
    public func toNoMoreDataState() {
        self.pullingIndicator.isHidden = true
        self.loaddingIndicator.isHidden = true
        self.loaddingIndicator.stopAnimating()
        
        self.messageLabel.text =  self.noMoreDataText
    }
    public func toWillRefreshState() {
        messageLabel.text =  self.releaseLoadMoreText
        UIView.animate(withDuration: 0.4, animations: {
            self.pullingIndicator.transform = CGAffineTransform.identity
        })
    }
    public func toRefreshingState() {
        self.loaddingIndicator.isHidden = false
        self.loaddingIndicator.startAnimating()
        
        messageLabel.text =  self.loaddingText
    }
    
}

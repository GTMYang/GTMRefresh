//
//  DefaultWebViewController.swift
//  PullToRefreshKit
//
//  Created by luoyang on 2016/12/8.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import Foundation
import UIKit

class DefaultWebViewController: UIViewController, UIWebViewDelegate{
    var webview:UIWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.webview = UIWebView(frame:view.bounds)
        self.webview?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.webview?.backgroundColor = UIColor.white
        view.addSubview(self.webview!)
        
        self.webview?.scrollView.gtm_addRefreshHeaderView(delegate: self)
//        self.webview?.scrollView.gtm_addRefreshHeaderView {
//            [unowned self] in
//            print("excute refreshBlock")
//            self.refresh()
//        }
//        
//        self.webview?.scrollView.gtm_addLoadMoreFooterView {
//            [unowned self] in
//            print("excute loadMoreBlock")
//            self.loadMore()
//        }
    }
    
}

import GTMRefresh
extension DefaultWebViewController: GTMRefreshHeaderDelegate {
    
    // MARK: - GTMRefreshHeaderDelegate
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    func endRefresing() {
        self.webview?.scrollView.endRefreshing(isSuccess: true)
    }
}

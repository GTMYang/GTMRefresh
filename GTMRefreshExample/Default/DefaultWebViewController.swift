//
//  DefaultWebViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/22.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class DefaultWebViewController: UIViewController,UIWebViewDelegate{
    var webview:UIWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webview = UIWebView(frame:view.bounds)
        self.webview?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.webview?.backgroundColor = UIColor.white
        view.addSubview(self.webview!)
        
        self.webview?.scrollView.gtm_addRefreshHeaderView {
            [unowned self] in
            print("excute refreshBlock")
            self.refresh()
        }
        
        self.webview?.scrollView.gtm_addLoadMoreFooterView {
            [unowned self] in
            print("excute loadMoreBlock")
            self.loadMore()
        }
    }
    
    
    // MARK: Test
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    func endRefresing() {
        self.webview?.scrollView.endRefreshing(isSuccess: true)
    }
    func loadMore() {
        perform(#selector(endLoadMore), with: nil, afterDelay: 3)
    }
    
    func endLoadMore() {
        self.webview?.scrollView.endLoadMore(isNoMoreData: true)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webview?.scrollView.endRefreshing(isSuccess: true)
    }
}

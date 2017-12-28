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
        
        self.webview?.scrollView.gtm_addRefreshHeaderView {
            [weak self] in
            print("excute refreshBlock")
            self?.refresh()
        }
        
        self.webview?.scrollView.gtm_addLoadMoreFooterView {
            [weak self] in
            print("excute loadMoreBlock")
            self?.loadMore()
        }
    }
    
    
    // MARK: Test
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    @objc func endRefresing() {
        self.webview?.scrollView.endRefreshing(isSuccess: true)
    }
    func loadMore() {
        perform(#selector(endLoadMore), with: nil, afterDelay: 3)
    }
    
    @objc func endLoadMore() {
        self.webview?.scrollView.endLoadMore(isNoMoreData: true)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webview?.scrollView.endRefreshing(isSuccess: true)
    }
}

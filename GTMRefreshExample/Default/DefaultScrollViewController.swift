//
//  DefaultScrollViewController.swift
//  PullToRefreshKit
//
//  Created by luoyang on 2016/12/8.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import Foundation
import UIKit
import GTMRefresh

class DefaultScrollViewController:UIViewController{
    var scrollView:UIScrollView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        setUpScrollView()
        
        self.scrollView?.gtm_addRefreshHeaderView(delegate: self)
//        self.scrollView?.gtm_addRefreshHeaderView {
//            [unowned self] in
//            print("excute refreshBlock")
//            self.refresh()
//        }
//        
//        self.scrollView?.gtm_addLoadMoreFooterView {
//            [unowned self] in
//            print("excute loadMoreBlock")
//            self.loadMore()
//        }
    }
    

    
    func setUpScrollView(){
        self.scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: 300,height: 300))
        self.scrollView?.backgroundColor = UIColor.lightGray
        self.scrollView?.center = self.view.center
        self.scrollView?.contentSize = CGSize(width: 300,height: 600)
        self.view.addSubview(self.scrollView!)
    }
}

import GTMRefresh
extension DefaultScrollViewController: GTMRefreshHeaderDelegate {
    
    // MARK: - GTMRefreshHeaderDelegate
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    func endRefresing() {
        self.scrollView?.endRefreshing(isSuccess: true)
    }
}

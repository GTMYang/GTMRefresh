//
//  QQVideoTableViewController.swift
//  PullToRefreshKit
//
//  Created by luoyang on 2016/12/8.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import Foundation
import UIKit

class QQVideoTableviewController:BaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let qqHeader = QQVideoRefreshHeader()
        self.tableView.gtm_addRefreshHeaderView(refreshHeader: qqHeader, delegate: self)
//        self.tableView.gtm_addRefreshHeaderView(refreshHeader: qqHeader) {
//            [unowned self] in
//            print("excute refreshBlock")
//            self.refresh()
//        }
        self.tableView.triggerRefreshing()
    }
    
}


import GTMRefresh
extension QQVideoTableviewController: GTMRefreshHeaderDelegate {
    
    // MARK: - GTMRefreshHeaderDelegate
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    func endRefresing() {
        self.tableView.endRefreshing(isSuccess: true)
    }
}

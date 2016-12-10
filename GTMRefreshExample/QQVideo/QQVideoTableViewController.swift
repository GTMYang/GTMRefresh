//
//  QQVideoTableViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/2.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class QQVideoTableviewController:BaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let qqHeader = QQVideoRefreshHeader()
        self.tableView.gtm_addRefreshHeaderView(refreshHeader: qqHeader) {
            [unowned self] in
            print("excute refreshBlock")
            self.refresh()
        }
        self.tableView.triggerRefreshing()
    }
    
    
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    func endRefresing() {
        self.tableView.endRefreshing(isSuccess: true)
    }
}

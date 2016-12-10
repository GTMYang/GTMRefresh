//
//  CurveMaskTableViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/4.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class CurveMaskTableViewController:BaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup
        let curveHeader = CurveRefreshHeader()
        self.tableView.gtm_addRefreshHeaderView(refreshHeader: curveHeader) {
            [unowned self] in
            print("excute refreshBlock")
            self.refresh()
        }
        self.tableView.autoRefreshing()
    }
    
    
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    func endRefresing() {
        self.tableView.endRefreshing(isSuccess: true)
    }

}

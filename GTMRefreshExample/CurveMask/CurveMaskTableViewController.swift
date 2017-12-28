//
//  CurveMaskTableViewController.swift
//  PullToRefreshKit
//
//  Created by luoyang on 2016/12/8.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import Foundation
import UIKit

class CurveMaskTableViewController:BaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup
        let curveHeader = CurveRefreshHeader()
        self.tableView.gtm_addRefreshHeaderView(refreshHeader: curveHeader) {
            [weak self] in
            print("excute refreshBlock")
            self?.refresh()
        }
        self.tableView.triggerRefreshing()
    }
    
    
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    @objc func endRefresing() {
        self.tableView.endRefreshing(isSuccess: true)
    }
    
}

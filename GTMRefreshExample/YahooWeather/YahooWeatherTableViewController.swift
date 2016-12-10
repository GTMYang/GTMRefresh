//
//  YahooWeatherTableViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/2.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class YahooWeatherTableViewController: BaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.lightGray
        //Setup
        let yahooHeader = YahooWeatherRefreshHeader()
        self.tableView.gtm_addRefreshHeaderView(refreshHeader: yahooHeader) {
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
    }}

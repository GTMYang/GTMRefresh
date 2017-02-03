//
//  WebviewController.swift
//  PullToRefreshKit
//
//  Created by luoyang on 2016/12/8.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import Foundation
import UIKit

class DefaultTableViewController:UITableViewController{
    var models = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.view.backgroundColor = UIColor.white
        //self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.tableView?.gtm_addRefreshHeaderView {
            [unowned self] in
            print("excute refreshBlock")
            self.refresh()
        }
//            .setupHeaderText(pullDownToRefreshText: "下拉试试看",
//                          releaseToRefreshText: "松开现神奇",
//                          refreshSuccessText: "成功",
//                          refreshFailureText: "失败",
//                          refreshingText: "刷新...")
//
        self.tableView?.gtm_addLoadMoreFooterView {
            [unowned self] in
            print("excute loadMoreBlock")
            self.loadMore()
        }
            //.setupFooterText(pullUpToRefreshText: "用力往上拉",
//                loaddingText: "努力加载中...",
//                noMoreDataText: "没有更多了",
//                releaseLoadMoreText: "轻轻一松，开始加载")
    }
    
    
    // MARK: Test
    func refresh() {
//        perform(#selector(endRefresing), with: nil, afterDelay: 3)
        endRefresing()
    }
    
    func endRefresing() {
        self.tableView?.endRefreshing(isSuccess: true)
    }
    func loadMore() {
        perform(#selector(endLoadMore), with: nil, afterDelay: 3)
    }
    
    func endLoadMore() {
        self.models += [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
        self.tableView?.endLoadMore(isNoMoreData: models.count > 50)
        self.tableView?.reloadData()
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(models[(indexPath as NSIndexPath).row])"
        return cell!
    }
    deinit{
        print("Deinit of DefaultTableViewController")
    }
}

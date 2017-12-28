//
//  ViewController.swift
//  GTMRefreshExample
//
//  Created by luoyang on 2016/12/6.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import UIKit
import GTMRefresh

class ViewController: UITableViewController {
    
    var models = [SectionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let section0 = SectionModel(rowsCount: 4,
                                    sectionTitle:"Default",
                                    rowsTitles: ["Tableview","CollectionView","ScrollView","WebView"],
                                    rowsTargetControlerNames:["DefaultTableViewController","DefaultCollectionViewController","DefaultScrollViewController","DefaultWebViewController"])
        
        
        let section1 = SectionModel(rowsCount: 7,
                                    sectionTitle:"Customize",
                                    rowsTitles: ["QQ","YahooWeather","Curve Mask","Youku","TaoBao","QQ Video","DianPing"],
                                    rowsTargetControlerNames:["QQStyleHeaderViewController","YahooWeatherTableViewController","CurveMaskTableViewController","YoukuTableViewController","TaobaoTableViewController","QQVideoTableviewController","DianpingTableviewController"])
        models.append(section0)
        models.append(section1)
        
        self.tableView.gtm_addRefreshHeaderView {
            [weak self] in
            print("excute refreshBlock")
            self?.refresh()
        }
        
        self.tableView.gtm_addLoadMoreFooterView {
            [weak self] in
            print("excute loadMoreBlock")
            self?.loadMore()
        }
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // text
        self.tableView.pullDownToRefreshText("亲，试试下拉会刷新的")
        .releaseToRefreshText("亲，松开试试")
        .refreshSuccessText("亲，成功了")
        .refreshFailureText("亲，无果")
        .refreshingText("亲，正在努力刷新")
        // color 
        self.tableView.headerTextColor(.red)
        // icon
        self.tableView.headerIdleImage(UIImage.init(named: "dropdown_anim__00048"))
        
    }
    
    
    // MARK: Test
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    @objc func endRefresing() {
        self.tableView.endRefreshing(isSuccess: true)
    }
    func loadMore() {
        perform(#selector(endLoadMore), with: nil, afterDelay: 3)
    }
    
    @objc func endLoadMore() {
        self.tableView.endLoadMore(isNoMoreData: true)
    }
    
    // MARK: Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionModel = models[section]
        return sectionModel.sectionTitle
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = models[section]
        return sectionModel.rowsCount
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            
        }
        let sectionModel = models[(indexPath as NSIndexPath).section]
        cell?.textLabel?.text = sectionModel.rowsTitles[(indexPath as NSIndexPath).row]
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionModel = models[(indexPath as NSIndexPath).section]
        var className = sectionModel.rowsTargetControlerNames[(indexPath as NSIndexPath).row]
        className = "GTMRefreshExample.\(className)"
        if let cls = NSClassFromString(className) as? UIViewController.Type{
            let dvc = cls.init()
            self.navigationController?.pushViewController(dvc, animated: true)
        }
        
    }
}


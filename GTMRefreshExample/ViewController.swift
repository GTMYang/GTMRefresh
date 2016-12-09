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
        
        let section0 = SectionModel(rowsCount: 1,
                                    sectionTitle:"Build In",
                                    rowsTitles: ["QQ Style",],
                                    rowsTargetControlerNames:["QQStyleHeaderViewController"])
     
        let section1 = SectionModel(rowsCount: 6,
                                    sectionTitle:"Customize",
                                    rowsTitles: ["YahooWeather","Curve Mask","Youku","TaoBao","QQ Video","DianPing"],
                                    rowsTargetControlerNames:["YahooWeatherTableViewController","CurveMaskTableViewController","YoukuTableViewController","TaobaoTableViewController","QQVideoTableviewController","DianpingTableviewController"])
        
        let section2 = SectionModel(rowsCount: 8,
                                    sectionTitle:"Test",
                                    rowsTitles: ["YahooWeather","Curve Mask","Youku","TaoBao","QQ Video","DianPing","Boys","Girls"],
                                    rowsTargetControlerNames:["YahooWeatherTableViewController","CurveMaskTableViewController","YoukuTableViewController","TaobaoTableViewController","QQVideoTableviewController","DianpingTableviewController","DianpingTableviewController","DianpingTableviewController"])
        models.append(section0)
        models.append(section1)
        models.append(section2)
        
        
        self.tableView.gtm_addRefreshHeaderView {
            [unowned self] in
            self.refresh()
        }
        
        self.tableView.gtm_addLoadMoreFooterView {
            [unowned self] in
            self.loadMore()
        }
    }
    
    
    // MARK: Test
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    func endRefresing() {
        self.tableView.endRefreshing(isSuccess: true)
    }
    func loadMore() {
        perform(#selector(endLoadMore), with: nil, afterDelay: 3)
    }
    
    func endLoadMore() {
        self.tableView.endLoadMore(isNoMoreData: false)
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


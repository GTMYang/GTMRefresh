//
//  GTMRefreshConstant.swift
//  GTMRefresh
//
//  Created by luoyang on 2016/12/7.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import UIKit

class GTMRefreshConstant {
    static let slowAnimationDuration: TimeInterval = 0.4
    static let fastAnimationDuration: TimeInterval = 0.25
    
    
    static let keyPathContentOffset: String = "contentOffset"
    static let keyPathContentInset: String = "contentInset"
    static let keyPathContentSize: String = "contentSize"
    static let keyPathPanState: String = "state"
    
    
    static var associatedObjectGtmHeader = 0
    static var associatedObjectGtmFooter = 1
}

func GTMRLocalize(_ string:String)->String{
    return NSLocalizedString(string, tableName: "Localize", bundle: Bundle(for: DefaultGTMRefreshHeader.self), value: "", comment: "")
}
struct GTMRHeaderString{
    static let pullDownToRefresh = GTMRLocalize("pullDownToRefresh")
    static let releaseToRefresh = GTMRLocalize("releaseToRefresh")
    static let refreshSuccess = GTMRLocalize("refreshSuccess")
    static let refreshFailure = GTMRLocalize("refreshFailure")
    static let refreshing = GTMRLocalize("refreshing")
}

struct GTMRFooterString{
    static let pullUpToRefresh = GTMRLocalize("pullUpToRefresh")
    static let refreshing = GTMRLocalize("refreshing")
    static let noMoreData = GTMRLocalize("noMoreData")
    static let tapToRefresh = GTMRLocalize("tapToRefresh")
    static let scrollAndTapToRefresh = GTMRLocalize("scrollAndTapToRefresh")
}

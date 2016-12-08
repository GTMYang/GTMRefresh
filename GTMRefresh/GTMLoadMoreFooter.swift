//
//  GTMRefreshFooter.swift
//  GTMRefresh
//
//  Created by luoyang on 2016/12/7.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import UIKit

public protocol SubGTMLoadMoreFooterProtocol {
    
}

open class GTMLoadMoreFooter: GTMRefreshComponent {
    
    /// 加载更多Block
    var loadMoreBlock: () -> Void = {}


}



class DefaultGTMLoadMoreFooter: GTMLoadMoreFooter {
    
}

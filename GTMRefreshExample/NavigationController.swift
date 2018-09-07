//
//  NavigationController.swift
//  EasyLife
//
//  Created by 骆扬 on 2018/7/24.
//  Copyright © 2018年 SyncSoft. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = NavigationControllerDelegate.shared
        self.interactivePopGestureRecognizer?.delegate = NavigationControllerDelegate.shared
    }
    
}


class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    static let shared = NavigationControllerDelegate()
    private override init() { }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let hide = viewController.isKind(of: DefaultTableViewController.self)
        navigationController.setNavigationBarHidden(hide, animated: animated)
    }
    
    
}


//extension UIViewController {
//    var isNavigationBarHidden: Bool {
//        if let controller = self as? BaseViewController {
//            return controller.hiddenNavigationBar
//        }
//        if let controller = self as? WebViewController {
//            return controller.hiddenNavigationBar
//        }
//        if self.isKind(of: UITabBarController.self) {
//            return true
//        }
//        return false
//    }
//}

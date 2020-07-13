//
//  AppDelegate+Extension.swift
//  GUL
//
//  Created by Shashikant's Mac on 9/17/19.
//  Copyright © 2019 redbytes. All rights reserved.
//

import UIKit

// MARK:- Extension for - AppDelegate
extension AppDelegate {
    
    /// Get Top viewController on app
    func rootController()-> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return self.rootController() ?? UIViewController()
    }
    
    /// Check All fonts and print them
    func printAllFonts() {
        for family: String in UIFont.familyNames {
            debugPrint("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                debugPrint("== \(names)")
            }
        }
    }
    
} //extension

// MARK:- Extension for - UIApplication
extension UIApplication {
    /// The app's key window taking into consideration apps that support multiple scenes.
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
} //extension

//
//  UIApplication+KeyWindow.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

public extension UIApplication {
    
    /// First `UIWindow` where `isKeyWindow`
    /// - Note:
    /// Named as such due to naming conflicts. TODO: Look to resolve
    var appKeyWindow: UIWindow? {
        return windows.first { $0.isKeyWindow } ?? windows.first
    }
    
    /// `visibleViewController` on the `rootViewController` of `keyWindow`
    var visibleViewController: UIViewController? {
        return appKeyWindow?.rootViewController?.visibleViewController
    }
}

// MARK: - UIViewController + VisibleViewController

public extension UIViewController {
    
    /// Visible `UIViewController` on `viewController`
    /// - Parameter viewController: `UIViewController`
    func visibleViewController(
        _ viewController: UIViewController
    ) -> UIViewController {
        
        // splitViewController
        if let splitViewController = viewController as? UISplitViewController,
            let firstViewController = splitViewController.viewControllers.first {
            return visibleViewController(firstViewController)
        }
        
        // navigationController
        if let navigationController = viewController as? UINavigationController,
            let lastViewController = navigationController.viewControllers.last {
            return visibleViewController(lastViewController)
        }
        
        // tabBarController
        if let tabController = viewController as? UITabBarController {
            if let selectedViewController = tabController.selectedViewController {
                return visibleViewController(selectedViewController)
            }
        }
        
        // presentedViewController
        if let presentedViewController = viewController.presentedViewController {
            return visibleViewController(presentedViewController)
        }
        
        return viewController
    }
    
    /// `visibleViewController(_:)` with `self`
    var visibleViewController: UIViewController {
        return visibleViewController(self)
    }
}

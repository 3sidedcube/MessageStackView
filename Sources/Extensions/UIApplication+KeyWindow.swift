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
        guard let rootViewController = appKeyWindow?.rootViewController else {
            return nil
        }
        return rootViewController.visibleViewController(
            from: rootViewController
        )
    }
}

// MARK: - UIViewController + VisibleViewController

public extension UIViewController {
    
    /// Visible `UIViewController` from `viewController`
    ///
    /// - Parameters:
    ///   - viewController: `UIViewController`
    ///   - includeSystemViewControllers: `Bool` include `UIViewController`s which
    ///   are presented and return `true` to `isSystemViewController`
    func visibleViewController(
        from viewController: UIViewController,
        includeSystemViewControllers: Bool = false
    ) -> UIViewController {
        
        // splitViewController
        if let splitViewController = viewController as? UISplitViewController,
            let firstViewController = splitViewController.viewControllers.first {
            return visibleViewController(from: firstViewController)
        }
        
        // navigationController
        if let navigationController = viewController as? UINavigationController,
            let lastViewController = navigationController.viewControllers.last {
            return visibleViewController(from: lastViewController)
        }
        
        // tabBarController
        if let tabController = viewController as? UITabBarController {
            if let selectedViewController = tabController.selectedViewController {
                return visibleViewController(from: selectedViewController)
            }
        }
        
        // presentedViewController
        if let presentedViewController = viewController.presentedViewController,
            (includeSystemViewControllers || !presentedViewController.isSystemViewController) {
            return visibleViewController(from: presentedViewController)
        }
        
        return viewController
    }
}

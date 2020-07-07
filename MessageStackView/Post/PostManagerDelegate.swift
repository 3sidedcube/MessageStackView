//
//  PostManagerDelegate.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

// MARK: - PostManagerDelegate

/// Delegate methods for `PostManager`
public protocol PostManagerDelegate: AnyObject {
    
    /// Called when a `view` will be posted
    /// - Parameters:
    ///   - postManager: `PostManager`
    ///   - view: The `UIView` that will be posted
    func postManager(
        _ postManager: PostManager,
        willPost view: UIView
    )
    
    /// Called when a `view` was posted
    /// - Parameters:
    ///   - postManager: `PostManager`
    ///   - view: The `UIView` that was posted
    func postManager(
        _ postManager: PostManager,
        didPost view: UIView
    )
    
    /// Called when a `view` will be removed
    /// - Parameters:
    ///   - postManager: `PostManager`
    ///   - view: The `UIView` that will be removed
    func postManager(
        _ postManager: PostManager,
        willRemove view: UIView
    )
    
    /// Called when a `view` was removed
    /// - Parameters:
    ///   - postManager: `PostManager`
    ///   - view: The `UIView` that was removed
    func postManager(
        _ postManager: PostManager,
        didRemove view: UIView
    )
}

/// Provide default implementation of `PostManagerDelegate` optional methods
public extension PostManagerDelegate {
    
    func postManager(
        _ postManager: PostManager,
        willPost view: UIView
    ){
    }
    
    func postManager(
        _ postManager: PostManager,
        didPost view: UIView
    ){
    }
    
    func postManager(
        _ postManager: PostManager,
        willRemove view: UIView
    ){
    }
    
    func postManager(
        _ postManager: PostManager,
        didRemove view: UIView
    ){
    }
}

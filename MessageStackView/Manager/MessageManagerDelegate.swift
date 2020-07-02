//
//  MessageManagerDelegate.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MessageManagerDelegate

/// Delegate methods for `MessageManager`
public protocol MessageManagerDelegate: AnyObject {
    
    /// Called when a `view` will be posted
    /// - Parameters:
    ///   - messageManager: `MessageManager`
    ///   - view: The `UIView` that will be posted
    func messageManager(
        _ messageManager: MessageManager,
        willPost view: UIView
    )
    
    /// Called when a `view` was posted
    /// - Parameters:
    ///   - messageManager: `MessageManager`
    ///   - view: The `UIView` that was posted
    func messageManager(
        _ messageManager: MessageManager,
        didPost view: UIView
    )
    
    /// Called when a `view` will be removed
    /// - Parameters:
    ///   - messageManager: `MessageManager`
    ///   - view: The `UIView` that will be removed
    func messageManager(
        _ messageManager: MessageManager,
        willRemove view: UIView
    )
    
    /// Called when a `view` was removed
    /// - Parameters:
    ///   - messageManager: `MessageManager`
    ///   - view: The `UIView` that was removed
    func messageManager(
        _ messageManager: MessageManager,
        didRemove view: UIView
    )
}

/// Provide default implementation of `MessageManagerDelegate` optional methods
public extension MessageManagerDelegate {
    
    func messageManager(
        _ messageManager: MessageManager,
        willPost view: UIView
    ){
    }
    
    func messageManager(
        _ messageManager: MessageManager,
        didPost view: UIView
    ){
    }
    
    func messageManager(
        _ messageManager: MessageManager,
        willRemove view: UIView
    ){
    }
    
    func messageManager(
        _ messageManager: MessageManager,
        didRemove view: UIView
    ){
    }
}

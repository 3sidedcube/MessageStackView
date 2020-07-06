//
//  MessageStackViewDelegate.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MessageStackViewDelegate

/// Delegate methods for `MessageStackView`
public protocol MessageStackViewDelegate: AnyObject {
    
    /// Called when a `view` will be posted
    /// - Parameters:
    ///   - messageStackView: `MessageStackView`
    ///   - view: The `UIView` that will be posted
    func messageStackView(
        _ messageStackView: MessageStackView,
        willPost view: UIView
    )
    
    /// Called when a `view` was posted
    /// - Parameters:
    ///   - messageStackView: `MessageStackView`
    ///   - view: The `UIView` that was posted
    func messageStackView(
        _ messageStackView: MessageStackView,
        didPost view: UIView
    )
    
    /// Called when a `view` will be removed
    /// - Parameters:
    ///   - messageStackView: `MessageStackView`
    ///   - view: The `UIView` that will be removed
    func messageStackView(
        _ messageStackView: MessageStackView,
        willRemove view: UIView
    )
    
    /// Called when a `view` was removed
    /// - Parameters:
    ///   - messageStackView: `MessageStackView`
    ///   - view: The `UIView` that was removed
    func messageStackView(
        _ messageStackView: MessageStackView,
        didRemove view: UIView
    )
}

/// Provide default implementation of `MessageStackViewDelegate` optional methods
public extension MessageStackViewDelegate {
    
    func messageStackView(
        _ messageStackView: MessageStackView,
        willPost view: UIView
    ){
    }
    
    func messageStackView(
        _ messageStackView: MessageStackView,
        didPost view: UIView
    ){
    }
    
    func messageStackView(
        _ messageStackView: MessageStackView,
        willRemove view: UIView
    ){
    }
    
    func messageStackView(
        _ messageStackView: MessageStackView,
        didRemove view: UIView
    ){
    }
}

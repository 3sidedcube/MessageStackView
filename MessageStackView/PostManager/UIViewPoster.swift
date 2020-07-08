//
//  UIViewPoster.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

/// `UIViewPoster` is sent messages to post and remove `UIView`s.
/// It should handle any animation and execute a given closure on completion.
internal protocol UIViewPoster: class {
    
    // MARK: - Post
    
    /// Post `view` with animation if `animated`
    ///
    /// - Parameters:
    ///   - view: `UIView` to post
    ///   - animated: Should we animate the post
    ///   - completion: Closure to be executed on completion, animated or not
    func post(
        view: UIView, animated: Bool, completion: @escaping () -> Void
    )
    
    /// Should `view` be posted
    ///
    /// - Parameter view: `UIView`
    func shouldPost(view: UIView) -> Bool
    
    // MARK: - Remove
    
    /// Remove `view` with animation if `animated`
    ///
    /// - Parameters:
    ///   - view: `UIView` to remove
    ///   - animated: Should we animate the removal
    ///   - completion: Closure to be executed on completion, animated or not
    func remove(
        view: UIView, animated: Bool, completion: @escaping () -> Void
    )
    
    /// Should `view` be removed
    ///
    /// - Parameter view: `UIView`
    func shouldRemove(view: UIView) -> Bool
}

// MARK: - UIViewPoster + Default

internal extension UIViewPoster {
    
    func shouldPost(view: UIView) -> Bool {
        return true // By default allow post
    }
    
    func shouldRemove(view: UIView) -> Bool {
        return true // By default allow remove
    }
}

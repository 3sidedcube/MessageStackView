//
//  UIView+MessageStackView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView + Poster

public extension UIView {
    
    /// Get the first `MessageStackView` or create and add to top of `self`.
    ///
    /// - Note:
    /// This is only desired when only `MessageStackView` exists as a subview of a `UIView`.
    /// This is the common use case. But it may be practical to have one at the top and another at
    /// the bottom. In this case one must keep a reference to the `MessageStackView`s.
    ///
    /// - Returns: `MessageStackView`
    func posterViewOrCreate<T>() -> T where T : UIView, T : Poster {
        // Get first `T`
        let subview = subviews
            .compactMap { $0 as? T }
            .first
        
        // If non `nil`, return it
        if let posterView = subview {
            return posterView
        }
        
        // Otherwise create it and add to top
        let posterView = T()
        posterView.addTo(view: self, layout: .top)
        return posterView
    }
    
    /// `MessageStackView` or create and constrain
    func messageStackViewOrCreate() -> MessageStackView {
        return posterViewOrCreate()
    }
    
    /// `PostView` or create and constrain
    func postViewOrCreate() -> PostView {
        return posterViewOrCreate()
    }
}

// MARK: - UIViewController + MessageStackView

public extension UIViewController {
    
    /// `MessageStackView` or create and constrain on `view`
    func messageStackViewOrCreate() -> MessageStackView {
        return view.messageStackViewOrCreate()
    }
    
    /// `PostView` or create and constrain on `view`
    func postViewOrCreate() -> PostView {
        return view.posterViewOrCreate()
    }
}

// MARK: - UIApplication + PostView

public extension UIApplication {
    
    /// `MessageStackView` or create and constrain
    func postViewOrCreate() -> PostView? {
        return firstKeyWindow?.postViewOrCreate()
    }
}

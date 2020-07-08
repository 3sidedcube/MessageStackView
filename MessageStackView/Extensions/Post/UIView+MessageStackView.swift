//
//  UIView+MessageStackView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    /// Get the first `MessageStackView` or create and add to top of `self`.
    ///
    /// - Note:
    /// This is only desired when only `MessageStackView` exists as a subview of a `UIView`.
    /// This is the common use case. But it may be practical to have one at the top and another at
    /// the bottom. In this case one must keep a reference to the `MessageStackView`s.
    ///
    /// - Returns: `MessageStackView`
    func messageStackViewOrCreate() -> MessageStackView {
        // Get first `MessageStackView`
        let subview = subviews
            .compactMap { $0 as? MessageStackView }
            .first
        
        // If non `nil`, return it
        if let messageStackView = subview {
            return messageStackView
        }
        
        // Otherwise create it and add to top
        let messageStackView = MessageStackView()
        messageStackView.addTo(view: self, layout: .top)
        return messageStackView
    }
}

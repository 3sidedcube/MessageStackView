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
    
    /// Get the first `MessageStackView` or create and add to top of `self`
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
        messageStackView.addTo(.top(self))
        return messageStackView
    }
}

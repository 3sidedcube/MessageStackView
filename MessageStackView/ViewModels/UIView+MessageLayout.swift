//
//  UIView+MessageLayout.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    /// Layout the `UIView` with a common `MessageLayout` use case: `layout`.
    ///
    /// - Note:
    /// Custom layout is supported, simply add `self` as a subview to  a desired `UIView` and
    /// constrain it accordingly as you would any other view.
    func addTo(_ layout: MessageLayout) {
        // Remove from previous layout tree if exists
        removeFromSuperview()
        
        // Constrain `self`
        layout.constrain(subview: self)
        
        // Trigger a layout cycle
        layout.view.setNeedsLayout()
    }
}

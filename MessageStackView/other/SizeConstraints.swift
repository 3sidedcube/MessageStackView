//
//  SizeConstraints.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/12/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

/// `SizeConstraints` for the width and height `NSLayoutConstraint`s on a `UIView`
struct SizeConstraints {
    
    /// Width `NSLayoutConstraint`
    var width: NSLayoutConstraint
    
    /// Height `NSLayoutConstraint`
    var height: NSLayoutConstraint
    
    /// Set the `constant` on the `width`
    func setWidth(constant: CGFloat) {
        width.constant = constant
    }
    
    /// Set the `constant` on the `height`
    func setHeight(constant: CGFloat) {
        height.constant = constant
    }
    
    /// The `width` and `height` `NSLayoutConstraint`s
    var constraints: [NSLayoutConstraint] {
        return [width, height]
    }
}

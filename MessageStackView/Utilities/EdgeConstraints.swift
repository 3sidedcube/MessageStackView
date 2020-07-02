//
//  EdgeConstraints.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

/// Constraints of the following form:
/// `view1.anchor = m * view2.anchor + c`
/// where:
/// - `m`: Multiplier
/// - `c`: Constant
///
/// - Note:
/// When talking about `UIEdgeInsets`, the value of `c` would refer to the opposite direction
struct EdgeConstraints {
    
    /// Leading anchor
    var leading: NSLayoutConstraint
    
    /// Top anchor
    var top: NSLayoutConstraint
    
    /// Trailing anchor
    var trailing: NSLayoutConstraint
    
    /// Bottom anchor
    var bottom: NSLayoutConstraint
    
    // MARK: - Computed
    
    /// All `NSLayoutConstraint`s of `EdgeConstraints`
    var constraints: [NSLayoutConstraint] {
        return [leading, top, trailing, bottom]
    }
    
    /// Constants of `constraints`
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsets(
                top: top.constant,
                left: leading.constant,
                bottom: -bottom.constant,
                right: -trailing.constant
            )
        }
        set {
            leading.constant = newValue.left
            top.constant = newValue.top
            trailing.constant = -newValue.right
            bottom.constant = -newValue.bottom
        }
    }
    
    /// Activate `constraints`
    func activate() {
        NSLayoutConstraint.activate(constraints)
    }
}

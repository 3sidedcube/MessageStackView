//
//  UIEdgeInsets+Extensions.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    
    /// Set all properties:
    /// `top`, `left`, `bottom`, `right`
    /// to the same given `value`
    /// - Parameter value: Fixed value for all properties
    init (value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    /// Sum `left` and `right`
    var horizontalSum: CGFloat {
        return left + right
    }

    /// Sum `top` and `bottom`
    var verticalSum: CGFloat {
        return top + bottom
    }
}

//
//  UIView+Extensions.swift
//  MessageStackView
//
//  Created by Ben Shutt on 08/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// Find the first superview (recursive) of type `T`.
    /// - Parameters:
    ///   - includeSelf: If `self` is of type `T` then return `self`
    func firstSuperviewOfType<T>(includeSelf: Bool = true) -> T? {
        if let view = self as? T, includeSelf {
            return view
        }
        
        return superview?.firstSuperviewOfType(includeSelf: true)
    }
    
    /// Bring `self` to front of `superview` `subviews` stack
    func bringToFront() {
        superview?.bringSubviewToFront(self)
    }
}

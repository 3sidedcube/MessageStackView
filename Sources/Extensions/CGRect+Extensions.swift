//
//  CGRect+Extensions.swift
//  MessageStackView
//
//  Created by Ben Shutt on 28/05/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {

    /// `CRect` with `.zero` origin and `self.size` set to the given `size`
    /// - Parameter size: `CGSize`
    init (size: CGSize) {
        self.init()
        self.origin = .zero
        self.size = size
    }

    /// Inset a `CGRect` by `values`
    /// - Parameter value: Amount to inset
    func inset(by value: CGFloat) -> CGRect {
        return self.inset(by: UIEdgeInsets(value: value))
    }

    /// `CGRect` centered about `self` with size `size`
    /// - Parameter size: Size of square rect
    func centered(size: CGFloat) -> CGRect {
        return CGRect(
            x: (width - size) * 0.5,
            y: (height - size) * 0.5,
            width: size,
            height: size
        )
    }

    /// Center `CGPoint` defined as:
    /// - `x` equals half the `width` and
    /// - `y` equals half the `height`
    var center: CGPoint {
        return CGPoint(x: width * 0.5, y: height * 0.5)
    }

    /// "Circle" `CGRect` at the given `center` with `radius`.
    /// Of course the `CGRect` is a square by definition
    /// - Parameters:
    ///   - center: Central axis point
    ///   - radius: Radius
    func rect(for center: CGPoint, radius: CGFloat) -> CGRect {
        return CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: 2 * radius,
            height: 2 * radius
        )
    }
}

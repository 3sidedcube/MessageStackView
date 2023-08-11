//
//  SizeConstraints.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/12/2019.
//  Copyright © 2019 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

/// `SizeConstraints` for the width and height `NSLayoutConstraint`s on a `UIView`
struct SizeConstraints: Constrainable {

    /// Width `NSLayoutConstraint`
    var width: NSLayoutConstraint

    /// Height `NSLayoutConstraint`
    var height: NSLayoutConstraint

    // MARK: - Setters

    /// Set the `constant` on the `width`
    ///
    /// - Parameter value: `width`  value
    func setWidth(_ value: CGFloat) {
        width.constant = value
    }

    /// Set the `constant` on the `height`
    /// 
    /// - Parameter constant: `height` value
    func setHeight(_ value: CGFloat) {
        height.constant = value
    }

    /// Set the `constant` on the `width` and `height`
    /// 
    /// - Parameter size: `CGSize`
    func setSize(_ size: CGSize) {
        setWidth(size.width)
        setHeight(size.width)
    }

    // MARK: - Constrainable

    /// The `width` and `height` `NSLayoutConstraint`s
    var constraints: [NSLayoutConstraint] {
        return [width, height]
    }
}

// MARK: - UIView + SizeConstraints

extension UIView {

    /// Construct `SizeConstraints` `NSLayoutConstraint`s on
    /// `self` to with constants of the given `size`
    ///
    /// - Parameters:
    ///   - size: `CGSize` of `NSLayoutConstraint` constants
    ///   - activate: Activate the `NSLayoutConstraint`s
    @discardableResult
    func sizeConstraints(
        size: CGSize,
        activate: Bool = true
    ) -> SizeConstraints {
        translatesAutoresizingMaskIntoConstraints = false

        let sizeConstraints = SizeConstraints(
            width: widthAnchor.constraint(equalToConstant: size.width),
            height: heightAnchor.constraint(equalToConstant: size.height)
        )

        if activate {
            sizeConstraints.activate()
        }

        return sizeConstraints
    }
}

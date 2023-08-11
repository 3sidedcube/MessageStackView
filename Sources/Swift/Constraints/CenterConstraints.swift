//
//  CenterConstraints.swift
//  MessageStackView
//
//  Created by Ben Shutt on 08/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// Constraints of the following form:
/// `view1.centerX = view2.centerX`
/// `view1.centerY = view2.centerY`
///
/// - Note:
/// When talking about `UIEdgeInsets` for trailing and bottom, the value of `c` would refer to
/// the opposite direction
struct CenterConstraints: Constrainable {

    /// Center X `NSLayoutConstraint`
    var centerX: NSLayoutConstraint

    /// Center Y `NSLayoutConstraint`
    var centerY: NSLayoutConstraint

    // MARK: - Constrainable

    /// All `NSLayoutConstraint`s of `Center`
    var constraints: [NSLayoutConstraint] {
        return [centerX, centerY]
    }
}

// MARK: - UIView + EdgeConstraints

extension UIView {

    /// Construct `CenterConstraints` `NSLayoutConstraint`s from
    /// `self` to `view`
    ///
    /// - Parameters:
    ///   - view: `UIView` to constrain to
    ///   - activate: Activate the `NSLayoutConstraint`s
    @discardableResult
    func centerConstraints(
        to view: UIView,
        activate: Bool = true
    ) -> CenterConstraints {
        translatesAutoresizingMaskIntoConstraints = false

        // Create `NSLayoutConstraint`s to the center anchors
        let centerConstraints = CenterConstraints(
            centerX: centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerY: centerYAnchor.constraint(equalTo: view.centerYAnchor)
        )

        // Activate `NSLayoutConstraint`s if required
        if activate {
            centerConstraints.activate()
        }

        return centerConstraints
    }
}

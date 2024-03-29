//
//  EdgeConstraints.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
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
/// When talking about `UIEdgeInsets` for trailing and bottom, the value of `c` would refer to
/// the opposite direction
struct EdgeConstraints: Constrainable {

    /// Leading anchor
    var leading: NSLayoutConstraint

    /// Top anchor
    var top: NSLayoutConstraint

    /// Trailing anchor
    var trailing: NSLayoutConstraint

    /// Bottom anchor
    var bottom: NSLayoutConstraint

    // MARK: - Constrainable

    /// All `NSLayoutConstraint`s of `EdgeConstraints`
    var constraints: [NSLayoutConstraint] {
        return [leading, top, trailing, bottom]
    }

    // MARK: - UIEdgeInsets

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
}

// MARK: - UIView + EdgeConstraints

extension UIView {

    /// Construct `EdgeConstraints` `NSLayoutConstraint`s from `self` to `view`
    ///
    /// - Parameters:
    ///   - view: `UIView` to constrain to
    ///   - insets: `UIEdgeInsets` to inset
    ///   - safeAreaLayoutGuide: `Bool` constrain to `view`'s `safeAreaLayoutGuide`
    ///   - activate: Activate the `NSLayoutConstraint`s
    @discardableResult
    func edgeConstraints(
        to view: UIView,
        insets: UIEdgeInsets = .zero,
        safeAreaLayoutGuide: Bool = false,
        activate: Bool = true
    ) -> EdgeConstraints {
        translatesAutoresizingMaskIntoConstraints = false

        // `EdgeLayoutGuide` of `view` to constrain `self` to
        let viewLayoutGuide: EdgeLayoutGuide =
            safeAreaLayoutGuide ? view.safeAreaLayoutGuide : view

        // Create `NSLayoutConstraint`s to the edge anchors
        var edgeConstraints = EdgeConstraints(
            leading: leadingAnchor.constraint(equalTo: viewLayoutGuide.leadingAnchor),
            top: topAnchor.constraint(equalTo: viewLayoutGuide.topAnchor),
            trailing: trailingAnchor.constraint(equalTo: viewLayoutGuide.trailingAnchor),
            bottom: bottomAnchor.constraint(equalTo: viewLayoutGuide.bottomAnchor)
        )

        // Set `UIEdgeInsets` as provided
        edgeConstraints.insets = insets

        // Activate `NSLayoutConstraint`s if required
        if activate {
            edgeConstraints.activate()
        }

        return edgeConstraints
    }
}

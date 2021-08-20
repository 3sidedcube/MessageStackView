//
//  MessageLayout.swift
//  MessageStackView
//
//  Created by Ben Shutt on 25/11/2019.
//  Copyright © 2019 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

/// Common use cases for constraining a`UIView` in the context of posting a message.
///
/// - Note:
/// `MessageLayout` is not required, one may opt to constrain explicitly instead.
public enum MessageLayout: Int {

    /// Constrain a `UIView` to the top of `UIView`
    case top

    /// Constrain a `UIView` to the bottom of another `UIView`
    case bottom
}

// MARK: - Order

public extension MessageLayout {

    /// Map to `Order`
    func toOrder() -> Order {
        switch self {
        case .top: return .topToBottom
        case .bottom: return .bottomToTop
        }
    }
}

// MARK: - NSLayoutConstraint

public extension MessageLayout {

    /// Constrain `subview` to `superview` based on `self` (`MessageLayout`).
    /// - Parameters:
    ///   - subview: `UIView` to add as a subview to `superview`
    ///   - superview: `UIView` superivew of `subview`
    ///   - safeAnchors: Constrain to safe anchors
    func constrain(
        subview: UIView,
        to superview: UIView,
        safeAnchors: Bool = true
    ) {
        superview.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false

        switch self {
        case .top:
            constrain(subview, to: superview, including: [
                subview.topAnchor.constraint(
                    equalTo: superview.topAnchor(safe: safeAnchors)
                )
            ], safeAnchors: safeAnchors)
        case .bottom:
            constrain(subview, to: superview, including: [
                subview.bottomAnchor.constraint(
                    equalTo: superview.bottomAnchor(safe: safeAnchors)
                )
            ], safeAnchors: safeAnchors)
        }
    }

    /// Constrain given `constraints` + leading and width anchor of `subview` to `superview`
    /// - Parameters:
    ///   - subview: `UIView` to add to `superview`
    ///   - superview: `UIView` to have `subview` added to
    ///   - constraints: Additional `NSLayoutConstraint`s
    private func constrain(
        _ subview: UIView,
        to superview: UIView,
        including constraints: [NSLayoutConstraint],
        safeAnchors: Bool
    ) {
        NSLayoutConstraint.activate(constraints + [
            subview.leadingAnchor.constraint(
                equalTo: superview.leadingAnchor(safe: safeAnchors)
            ),
            subview.widthAnchor.constraint(
                equalTo: superview.widthAnchor(safe: safeAnchors)
            )
        ])
    }
}

// MARK: - UIView + MessageLayout

public extension UIView {

    /// Layout `self` with `layout` (a common `MessageLayout` use case).
    ///
    /// - Note:
    /// Custom layout is supported, simply add `self` as a subview to  a desired `UIView` and
    /// constrain it accordingly as you would any other view.
    ///
    /// - Parameters:
    ///   - view: `UIView` superview to add `self` to
    ///   - layout: `MessageLayout`
    ///   - constrainToSafeArea: Constrain to safe area anchors
    func addTo(
        view: UIView,
        layout: MessageLayout,
        constrainToSafeArea: Bool = true
    ) {
        // Remove from previous layout tree if exists
        removeFromSuperview()

        // Constrain `self`
        layout.constrain(
            subview: self, to: view, safeAnchors: constrainToSafeArea
        )

        // Trigger a layout cycle
        view.setNeedsLayout()
    }
}

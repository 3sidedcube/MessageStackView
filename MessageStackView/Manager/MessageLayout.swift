//
//  MessageLayout.swift
//  MessageStackView
//
//  Created by Ben Shutt on 25/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

/// Common use cases for constraining a`UIView` in the context of posting a message.
///
/// - Note:
/// `MessageLayout` is not required, one may opt to constrain explicitly instead.
public enum MessageLayout {
    
    /// Constrain `MessageStackView` to safe top, safe leading, and safe width of given `UIView`
    case top(UIView)
    
    /// Constrain `MessageStackView` to safe bottom, safe leading, and safe width of given `UIView`
    case bottom(UIView)
}

// MARK: - View

public extension MessageLayout {
    
    /// Superview of the `MessageStackView`
    var view: UIView {
        switch self {
        case .top(let view): return view
        case .bottom(let view): return view
        }
    }
}

// MARK: - NSLayoutConstraint

public extension MessageLayout {

    /// Constrain `MessageStackView` based on `MessageLayout` value
    /// - Parameter subview: `UIView` to add as a subview to `self.view`
    func constrain(subview: UIView) {
        let superview = self.view
        
        superview.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        switch self {
        case .top(let viewToAddTo):
            constrain(subview, superview: superview, including: [
                subview.topAnchor.constraint(equalTo: viewToAddTo.safeTopAnchor)
            ])
        case .bottom(let viewToAddTo):
            constrain(subview, superview: superview, including: [
                subview.bottomAnchor.constraint(equalTo: viewToAddTo.safeBottomAnchor)
            ])
        }
    }
    
    /// Constrain given `constraints` + leading and width anchor of `subview` to `superview`
    /// - Parameters:
    ///   - subview: `UIView` to add to `superview`
    ///   - superview: `UIView` to have `subview` added to
    ///   - constraints: Additional `NSLayoutConstraint`s
    private func constrain(
        _ subview: UIView,
        superview: UIView,
        including constraints: [NSLayoutConstraint]
    ){
        NSLayoutConstraint.activate(constraints + [
            subview.leadingAnchor.constraint(equalTo: superview.safeLeadingAnchor),
            subview.widthAnchor.constraint(equalTo: superview.safeWidthAnchor)
        ])
    }
}

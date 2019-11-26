//
//  MessageLayout.swift
//  MessageStackView
//
//  Created by Ben Shutt on 25/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

public enum MessageLayout {
    /// Constrain `MessageStackView` to safe top, safe leading, and safe width of given `UIView`
    case top(UIView)
    
    /// Constrain `MessageStackView` to safe bottom, safe leading, and safe width of given `UIView`
    case bottom(UIView)
    
    /// Closure responsible for constraints of `MessageStackView`
    case custom(UIView, (MessageStackView) -> Void)
    
    /// Superview of the `MessageStackView`
    var view: UIView {
        switch self {
        case .top(let view): return view
        case .bottom(let view): return view
        case .custom(let view, _): return view
        }
    }
}

// MARK: - NSLayoutConstraint

extension MessageLayout {

    func constrain(subview: MessageStackView) {
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
        case .custom(_, let closure):
            closure(subview)
        }
    }
    
    private func constrain(_ subview: UIView, superview: UIView, including constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.activate(constraints + [
            subview.leadingAnchor.constraint(equalTo: superview.safeLeadingAnchor),
            subview.widthAnchor.constraint(equalTo: superview.safeWidthAnchor)
        ])
    }
    
}

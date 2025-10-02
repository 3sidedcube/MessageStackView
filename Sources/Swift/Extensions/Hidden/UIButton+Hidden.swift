//
//  UIButton+Hidden.swift
//  MessageStackView
//
//  Created by Sam Davis on 29/11/2024.
//  Copyright © 2024 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    /// Set a title, add a `UIButton.action`, and update `isHidden` by nullability of `title`
    /// - Parameters:
    ///   - title: `String?`
    ///   - action: `UIAction?`
    func setAndHide(title: String? = nil, action: UIAction? = nil) {
        // Set visibility
        isHidden = title == nil

        // Set title
        setTitle(title, for: .normal)
        
        // Remove existing actions
        enumerateEventHandlers { existingAction, _, event, _ in
            guard let existingAction else { return }
            removeAction(existingAction, for: event)
        }
        
        if let action {
            addAction(action, for: .touchUpInside)
        }
    }
}

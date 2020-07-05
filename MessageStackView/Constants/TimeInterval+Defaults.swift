//
//  TimeInterval+Defaults.swift
//  MessageStackView
//
//  Created by Ben Shutt on 04/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation

// MARK: - TimeInterval + Defaults

extension TimeInterval {
    
    /// Animation duration when showing/hiding the `MessageView`s
    static let animationDuration: TimeInterval = 0.25
    
    /// Amount of time after posting to dismiss a `UIView`.
    /// When `nil`, do not dismiss.
    static let defaultDismiss: TimeInterval? = nil
}

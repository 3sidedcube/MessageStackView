//
//  TimeInterval+Defaults.swift
//  MessageStackView
//
//  Created by Ben Shutt on 04/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation

// MARK: - TimeInterval + Defaults

public extension TimeInterval {
    
    /// Animation duration when posting and removing the `UIView`s from the `MessageStackView`
    static let animationDuration: TimeInterval = 0.333
    
    /// Amount of time after posting to dismiss a `UIView`.
    /// When `nil`, do not dismiss by default.
    static let defaultDismiss: TimeInterval? = nil
    
    /// Default `TimeInterval` from posting to dismiss a message view
    static let defaultMessageDismiss: TimeInterval = 5
}

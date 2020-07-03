//
//  MessageDismiss.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

/// How long should a message be visible
public enum MessageDismiss {
    
    /// Dismiss a message after the given `TimeInterval` (seconds)
    case after(TimeInterval)
    
    /// Dismiss a message when it's tapped
    case onTap
    
    /// Don't dismiss the message after posting
    case never
}

public extension MessageDismiss {

    /// Validate the `MessageDismiss`
    func isValid() -> Bool {
        if case MessageDismiss.after(let timeInterval) = self {
            return timeInterval > 0
        }
        return true
    }
}

extension MessageDismiss {
    
    /// Default `MessageDismiss`
    public static let `default`: MessageDismiss = .after(3)
}

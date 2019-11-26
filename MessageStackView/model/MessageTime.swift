//
//  MessageDismiss.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

/// How long should a message be visible
public enum MessageDismiss
{
    /// Dismiss a message after the given `TimeInterval` (seconds)
    case after(TimeInterval)
    
    /// Don't dismiss the message after posting
    case never

    /// Validate the `MessageDismiss`
    public func isValid() -> Bool {
        if case MessageDismiss.after(let timeInterval) = self {
            return timeInterval > 0
        }
        return true
    }
}

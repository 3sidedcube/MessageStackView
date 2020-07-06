//
//  MessageViewable.swift
//  MessageStackView
//
//  Created by Ben Shutt on 04/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation

/// Handle a `Message`
public protocol MessageViewable {
    
    /// Apply the given `Message` model
    /// - Parameter message: `Message`
    func apply(message: Message)
}

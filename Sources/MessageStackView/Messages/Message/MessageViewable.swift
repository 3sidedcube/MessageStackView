//
//  MessageViewable.swift
//  MessageStackView
//
//  Created by Ben Shutt on 04/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// Handle a `Message`
public protocol MessageViewable {

    /// Apply the given `Message` model
    /// - Parameter message: `Message`
    func set(message: Message)
}

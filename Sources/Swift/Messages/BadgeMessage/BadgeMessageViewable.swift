//
//  BadgeMessageViewable.swift
//  MessageStackView
//
//  Created by Ben Shutt on 08/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// Handle a `BadgeMessage`
public protocol BadgeMessageViewable {

    /// Apply the given `BadgeMessage` model
    /// - Parameter badgeMessage: `BadgeMessage`
    func set(badgeMessage: BadgeMessage)
}

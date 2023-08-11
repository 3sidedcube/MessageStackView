//
//  BadgeMessageView+BadgeMessage.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// View-model applying model `BadgeMessage` to view `BadgeMessageView`
extension BadgeMessageView: BadgeMessageViewable {

    /// Apply `badgeMessage` model to `self` (`UIView`)
    /// - Parameter badgeMessage: `BadgeMessage`
    public func set(badgeMessage: BadgeMessage) {
        // title
        titleLabel.text = badgeMessage.title

        // subtitle
        subtitleLabel.text = badgeMessage.subtitle

        // fillColor
        badgeView.fillColor = badgeMessage.fillColor
        backgroundImageView.tintColor = badgeMessage.fillColor

        // image
        let image = badgeMessage.image?.withRenderingMode(.alwaysTemplate)
        badgeView.image = image
        backgroundImageView.image = image
    }
}

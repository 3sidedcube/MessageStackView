//
//  MessageView+Message.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// View-model applying model `Message` to view `MessageView`
extension MessageView: MessageViewable {

    /// Apply `Message` to `MessageView`
    /// - Parameter message: `Message`
    public func set(message: Message) {

        // Title
        titleLabel.setTextAndHidden(message.title)

        // Detail
        subtitleLabel.setTextAndHidden(message.subtitle)

        // Left Image
        leftImageView.setImageAndHidden(message.leftImage)

        // Right Image
        rightImageView.setImageAndHidden(message.rightImage)
    }
}

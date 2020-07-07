//
//  MessageView+Message.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

extension MessageView: MessageViewable {
    
    /// Apply `Message` to `MessageView`
    /// - Parameter message: `Message`
    public func apply(message: Message) {
        
        // Title
        titleLabel.text = message.title
        
        // Detail
        subtitleLabel.setTextAndHidden(message.subtitle)
        
        // Left Image
        leftImageView.setImageAndHidden(message.leftImage)
        
        // Right Image
        rightImageView.setImageAndHidden(message.rightImage)
    }
}
//
//  MessageStackView+Post.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Post

extension MessageStackView {
    
    /// Post a `Message` creating a `MessageView`
    ///
    /// - Parameters:
    ///     - message: A `Message` to post
    ///     - dismissAfter: After how long should we dismiss the `MessageView`
    ///     - animated: Animate the showing of the `MessageView`
    ///
    /// - Returns: The `MessageView` created and added to the `MessageStackView`
    @discardableResult
    public func post(
        message: Message,
        dismissAfter: TimeInterval? = nil,
        animated: PostAnimation = .default
    ) -> MessageView {
        
        // Create a `MessageView`
        let messageView = MessageView()
        
        // Apply message
        messageView.apply(message: message)
        
        // Post the message like any other `UIView`
        postManager.post(postRequest: PostRequest(
            view: messageView,
            dismissAfter: dismissAfter,
            animated: animated
        ))
        
        return messageView
    }
}

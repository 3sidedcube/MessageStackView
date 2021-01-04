//
//  MessageStackView+Post.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Post

extension Poster {

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
        dismissAfter: TimeInterval? = .defaultMessageDismiss,
        animated: PostAnimation = .default
    ) -> MessageView {

        // Create a `MessageView`
        let messageView = MessageView()

        // Apply message
        messageView.set(message: message)

        // Post the view
        postManager.post(postRequest: PostRequest(
            view: messageView,
            dismissAfter: dismissAfter,
            animated: animated
        ))

        return messageView
    }
}

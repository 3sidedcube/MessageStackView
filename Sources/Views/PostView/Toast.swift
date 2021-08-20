//
//  Toast.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/06/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// A `PostView` which looks like and behaves like a "Toast" on Android.
/// That is, a short message which pops in from the bottom of the screen to display a message.
open class Toast: PostView {

    // MARK: - Override

    override open var order: Order {
        return .bottomToTop
    }

    /// Constrain the given `subview`
    ///
    /// - Parameter subview: `UIView`
    override func constrain(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(
                equalTo: topAnchor,
                constant: edgeInsets.top
            ),
            subview.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -edgeInsets.bottom
            ),
            subview.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            subview.widthAnchor.constraint(
                lessThanOrEqualTo: widthAnchor,
                constant: -(edgeInsets.left + edgeInsets.right)
            )
        ])
    }

    // MARK: - Post

    /// Is the given `message` already being shown
    ///
    /// - Parameter message: `String` message to show
    open func isShowing(message: String) -> Bool {
        return postManager.currentPostRequests
            .compactMap { ($0.view as? MessageView)?.titleLabel.text }
            .contains(message)
    }

    /// Post a `message` if that message isn't already been shown
    ///
    /// - Parameters:
    ///   - message: `String` message to post
    ///   - dismissAfter: `TimeInterval`
    ///   - animated: `PostAnimation`
    ///
    /// - Returns: `MessageView`
    @discardableResult
    open func postIfNotShowing(
        message: String,
        dismissAfter: TimeInterval? = .defaultMessageDismiss,
        animated: PostAnimation = .default
    ) -> MessageView? {
        guard !isShowing(message: message) else { return nil }
        return post(
            message: message,
            dismissAfter: dismissAfter,
            animated: animated
        )
    }

    /// Post a `message`
    ///
    /// - Parameters:
    ///   - message: `String` message to post
    ///   - dismissAfter: `TimeInterval`
    ///   - animated: `PostAnimation`
    ///
    /// - Returns: `MessageView`
    @discardableResult
    open func post(
        message: String,
        dismissAfter: TimeInterval? = .defaultMessageDismiss,
        animated: PostAnimation = .default
    ) -> MessageView {
        let messageView = post(
            message: Message(title: message),
            dismissAfter: dismissAfter,
            animated: animated
        )

        messageView.clipsToBounds = true
        messageView.layer.cornerRadius = 5
        messageView.backgroundColor = .themeDarkGray
        messageView.titleLabel.textColor = .white
        messageView.titleLabel.font = UIFont.systemFont(
            ofSize: 16,
            weight: .regular
        )

        return messageView
    }
}

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
    
    /// Post a `Message`
    ///
    /// - Parameters:
    ///     - message: A `Message` to post
    ///     - dismiss: After how long should we dismiss the `MessageView`
    ///     - animated: Animate the showing of the `MessageView`
    ///
    /// - Returns: The `MessageView` created and added to the `messageStackView`
    @discardableResult
    public func post(
        message: Message,
        dismiss: MessageDismiss = .default,
        animated: PostAnimation = .default
    ) -> MessageView {
        
        // Create a `MessageView`
        let messageView = MessageView()
        
        // Apply message
        messageView.apply(message: message)
        
        // Post the message like any other `UIView`
        post(view: messageView, dismiss: dismiss, animated: animated)
        
        return messageView
    }
    
    /// Post a `UIView`.
    /// This `view` will be added to a `fill` distributed `UIStackView` so it's width will
    /// be determined the `UIStackView`.
    /// However it's height should be determined by the `view` itself.
    /// E.g. intrinsicContentSize, autolayout, explicit height...
    ///
    /// - Parameters:
    ///     - view: A `UIView` to post
    ///     - dismiss: After how long should we dismiss the `UIView`
    ///     - animated: Animate the showing of the `UIView`
    public func post(
        view: UIView,
        dismiss: MessageDismiss = .default,
        animated: PostAnimation = .default
    ){
        // Check arguments
        guard dismiss.isValid() else {
            fatalError("Invalid \(MessageDismiss.self)")
        }
        
        // Remove from previous layout tree if it exists
        view.removeFromSuperview()
        
        // Fire will post
        delegate?.messageStackView(self, willPost: view)
        
        // Add to the `messageStackView`
        addArrangedSubview(view)
        
        // Configure the message
        configure(view: view)
        
        // Animate if required
        if animated.contains(.onPost) {
            view.isHidden = true
            self.layoutIfNeeded()
            UIView.animate(withDuration: .animationDuration) {
                view.isHidden = false
                self.layoutIfNeeded()
                
                // Fire did post
                self.delegate?.messageStackView(self, didPost: view)
            }
        } else {
            // Fire did post
            self.delegate?.messageStackView(self, didPost: view)
        }
       
        // Stop here if the caller does not want to dismiss this message
        guard case MessageDismiss.after(let timeInterval) = dismiss else {
            if case MessageDismiss.onTap = dismiss {
                addTapGesture(to: view)
            }
            return
        }
        
        // Schedule timer to fire `remove` call
        timerMap[view] = Timer.scheduledTimer(
            withTimeInterval: timeInterval,
            repeats: false
        ) { [weak view, weak self] timer in
            if let view = view, let self = self {
                self.remove(view: view, animated: animated.contains(.onRemove))
            }
        }
    }
}

// MARK: - TimeInterval + Defaults

extension TimeInterval {
    
    /// Animation duration when showing/hiding the `MessageView`s
    static let animationDuration: TimeInterval = 0.25
}

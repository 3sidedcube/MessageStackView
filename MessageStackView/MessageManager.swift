//
//  MessageManager.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

/// Controller for posting and removing `Message`s on a `UIStackView`.
/// Custom `UIView`s are also supported.
///
/// `Timer` schedules for removing a message are handled by this class.
open class MessageManager {
    
    /// Default constants
    public struct Constants {
        /// Animation duration when showing/hiding the `MessageView`s
        static let animationDuration: TimeInterval = 0.25
    }
    
    /// Keep track of `Timer`s for views
    private var timerMap = [UIView: Timer]()
    
    /// `UIStackView` to post messages on to
    public private(set) lazy var messageStackView = MessageStackView()
    
    /// Default `MessageConfiguration` which describes the default look and feel of `MessageView`s.
    public var messageConfiguation = MessageConfiguration() {
        didSet {
            guard messageConfiguation.applyToAll else {
                return
            }
            
            // If the `messageConfiguation` has updated, update the current `MessageView`s
            let messageViews = messageStackView.arrangedSubviews.compactMap { $0 as? MessageView }
            messageViews.forEach {
                $0.apply(configuration: messageConfiguation)
            }
        }
    }
    
    // MARK: - Init
    
    /// Add `messageStackView` to `view` to prepare for posting messages
    public init () {
        // This view is for smooth animations when there are no arrangedSubviews in the stackView.
        // Otherwise the stackView can not determine it's width/height.
        // With "no arranged subviews", we want to fix the width according to it's constraints,
        // but have 0 height
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 0)
        ])
        messageStackView.addArrangedSubview(view)
    }
    
    /// Invalidate timers on deinit
    deinit {
        invalidate()
    }
    
    // MARK: - Layout
    
    /// Layout the `MessageStackView` with a common `MessafeLayout` use case.
    /// Custom layout is supported, simply add the `messageStackView` as a subview to a `UIView` and
    /// constrain it accordingly.
    public func addTo(_ layout: MessageLayout) {
        // Remove from previous layout tree
        if messageStackView.superview != nil {
            messageStackView.removeFromSuperview()
        }
        
        // Constrain the `MessageStackView`
        layout.constrain(subview: messageStackView)
        
        // Prevent the first animation also positioning the `messageStackView`
        layout.view.setNeedsLayout()
    }
    
    // MARK: - Post
    
    /// Post a `Message`
    ///
    /// - Parameters:
    ///     - message: A `Message` to post
    ///     - dismiss: After how long should we dismiss the `MessageView`
    ///     - animated: Animate the showing of the `MessageView`
    ///
    /// - Returns: The `MessageView` created and added to the `messageStackView`
    @discardableResult
    public func post(message: Message,
                     dismiss: MessageDismiss = .default,
                     animated: PostAnimation = .default) -> MessageView {
        
        // Create a `MessageView`
        let messageView = MessageView()
        
        // Apply message
        messageView.apply(message: message)
        
        // Apply configuration
        messageView.apply(configuration: messageConfiguation)
        
        post(view: messageView, dismiss: dismiss, animated: animated)
        return messageView
    }
    
    /// Post a `UIView`.
    /// This `view` will be added to a `fill` distributed `UIStackView` so it's width will be determined the `UIStackView`.
    /// However it's height should be determined by the `view` itself, e.g. intrinsicContentSize, autolayout, explicit height...
    ///
    /// - Parameters:
    ///     - view: A `UIView` to post
    ///     - dismiss: After how long should we dismiss the `UIView`
    ///     - animated: Animate the showing of the `UIView`
    public func post(view: UIView,
                     dismiss: MessageDismiss = .default,
                     animated: PostAnimation = .default) {
        
        // Check arguments
        guard dismiss.isValid() else {
            fatalError("Invalid \(MessageDismiss.self)")
        }
        
        // Add to the `messageStackView`
        messageStackView.addArrangedSubview(view)
        
        // Animate if required
        if animated.contains(.onPost) {
            view.isHidden = true
            messageStackView.layoutIfNeeded()
            UIView.animate(withDuration: Constants.animationDuration) {
                view.isHidden = false
                self.messageStackView.layoutIfNeeded()
            }
        }
       
        // Stop here if the caller does not want to dismiss this message
        guard case MessageDismiss.after(let timeInterval) = dismiss else {
            return
        }
        
        // Schedule timer to fire `remove` call
        timerMap[view] = Timer.scheduledTimer(
            withTimeInterval: timeInterval, repeats: false) { [weak view, weak self] timer in
                if let view = view, let self = self {
                    self.remove(view: view, animated: animated.contains(.onRemove))
                }
            }
    }
    
    // MARK: - Remove
    
    /// Remove a `MessageView`.
    /// Checks if the `messageView` superview is the `messageStackView`, if not, does nothing and simply returns
    ///
    /// - Parameters:
    ///     - messageView: `UIView` to remove
    ///     - animated: Whether to animate the removal of the `messageView`
    ///
    /// - Returns: The `MessageView` created and added to the `messageStackView`
    public func remove(view: UIView, animated: Bool = true) {
        timerMap[view]?.invalidate()
        timerMap[view] = nil
        
        guard view.superview == messageStackView else {
            return
        }
        
        guard animated else {
            view.removeFromSuperview()
            return
        }
        
        messageStackView.layoutIfNeeded()
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            view.isHidden = true
            self.messageStackView.layoutIfNeeded()
        }) { finished in
            // Apple docs say the stackView will remove it from its arrangedSubviews list automatically
            // when calling this method 
            view.removeFromSuperview()
        }
    }
    
    // MARK: - Invalidate
    
    /// Invalidate and remove timers
    public func invalidate() {
        timerMap.values.forEach {
            $0.invalidate()
        }
        timerMap = [UIView: Timer]()
    }
}


// MARK: - Extensions

extension MessageDismiss {
    
    /// Default `MessageDismiss`
    public static let `default`: MessageDismiss = .after(3)
}

extension PostAnimation {
    
    /// Default `PostAnimation`
    public static let `default`: PostAnimation = .both
}

extension MessageView {
    
    /// Apply `Message` to `MessageView`
    func apply(message: Message) {
        // Title
        titleLabel.text = message.title
        
        // Detail
        let subtitle = message.subtitle ?? ""
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle.isEmpty
        
        // Image
        imageView.image = message.image
        imageView.isHidden = message.image == nil
    }
    
    /// Apply `MessageConfiguration` to `MessageView`
    func apply(configuration: MessageConfiguration) {
        backgroundColor = configuration.backgroundColor
        tintColor = configuration.tintColor
        if configuration.shadow {
            addShadowBelow()
        } else {
            removeShadow()
        }
    }   
}

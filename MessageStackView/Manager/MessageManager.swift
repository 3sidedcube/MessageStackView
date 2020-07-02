//
//  MessageManager.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MessageManager

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
    
    /// Keep track of `Timer`s for removing `UIView`s that should only be around for a finite time
    private var timerMap = [UIView: Timer]()
    
    /// Map `UIView`s to their "tap to dismiss" `UITapGestureRecognizer`
    private var tapGestureMap = [UIView: UITapGestureRecognizer]()
    
    /// `UIStackView` to post messages on to
    public let messageStackView: MessageStackView
    
    /// Default `MessageConfiguration` which describes the default
    /// look and feel of `MessageView`s.
    public var messageConfiguation = MessageConfiguration() {
        didSet {
            guard messageConfiguation.applyToAll else {
                return
            }
            
            // If the `messageConfiguation` has updated, update
            // the current `UIView`s
            messageStackView.arrangedSubviewsExcludingSpace.forEach {
                configure(view: $0)
            }
        }
    }
    
    /// `MessageManagerDelegate`
    public weak var delegate: MessageManagerDelegate?
    
    // MARK: - Init
    
    /// Configure `messageStackView`
    public init () {
        messageStackView = MessageStackView()
    }
    
    /// Invalidate on deinit
    deinit {
        invalidate()
    }
    
    // MARK: - Layout
    
    /// Layout the `MessageStackView` with a common `MessafeLayout` use case.
    /// Custom layout is supported, simply add the `messageStackView` as a subview to a `UIView` and
    /// constrain it accordingly.
    public func addTo(_ layout: MessageLayout) {
        // Remove from previous layout tree if exists
        messageStackView.removeFromSuperview()
        
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
    /// This `view` will be added to a `fill` distributed `UIStackView` so it's width will be determined the `UIStackView`.
    /// However it's height should be determined by the `view` itself, e.g. intrinsicContentSize, autolayout, explicit height...
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
        delegate?.messageManager(self, willPost: view)
        
        // Add to the `messageStackView`
        messageStackView.addArrangedSubview(view)
        
        // Configure the message
        configure(view: view)
        
        // Animate if required
        if animated.contains(.onPost) {
            view.isHidden = true
            messageStackView.layoutIfNeeded()
            UIView.animate(withDuration: Constants.animationDuration) {
                view.isHidden = false
                self.messageStackView.layoutIfNeeded()
                
                // Fire did post
                self.delegate?.messageManager(self, didPost: view)
            }
        } else {
            // Fire did post
            self.delegate?.messageManager(self, didPost: view)
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
    
    // MARK: - Remove
    
    /// Remove a `MessageView`.
    /// Checks if the `messageView` superview is the `messageStackView`, if not,
    /// does nothing and simply returns
    ///
    /// - Parameters:
    ///     - messageView: `UIView` to remove
    ///     - animated: Whether to animate the removal of the `messageView`
    ///
    /// - Returns: The `MessageView` created and added to the `messageStackView`
    public func remove(view: UIView, animated: Bool = true) {
        timerMap[view]?.invalidate()
        timerMap[view] = nil
        
        removeTapGesture(from: view)
        
        guard view.superview == messageStackView else {
            return
        }
        
        // Fire will remove
        self.delegate?.messageManager(self, willRemove: view)
        
        guard animated else {
            view.removeFromSuperview()
            
            // Fire did remove
            self.delegate?.messageManager(self, didRemove: view)
            
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
            
            // Fire did remove
            self.delegate?.messageManager(self, didRemove: view)
        }
    }
    
    // MARK: - Configuration
    
    /// Configure a `view` conforming to `MessageConfigurable` or provide a default implementation
    public func configure(view: UIView) {
        if let configurableView = view as? MessageConfigurable {
            configurableView.apply(configuration: messageConfiguation)
        } else {
            view.defaultApply(configuration: messageConfiguation)
        }
    }
    
    // MARK: - Tap
    
    /// Add `UITapGestureRecognizer`
    fileprivate func addTapGesture(to view: UIView) {
        guard tapGestureMap[view] == nil else {
            return
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureMap[view] = tap
        view.addGestureRecognizer(tap)
    }
    
    /// Remove `UITapGestureRecognizer`
    fileprivate func removeTapGesture(from view: UIView) {
        guard let tap = tapGestureMap[view] else {
            return
        }
        
        tapGestureMap[view] = nil
        view.removeGestureRecognizer(tap)
    }
    
    /// When a `UIView` wants to be dismissed on tap,
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended, let view = sender.view else {
            return
        }
        remove(view: view, animated: true)
    }
    
    // MARK: - Invalidate
    
    /// Invalidate and remove timers
    public func invalidate() {
        messageStackView.arrangedSubviewsExcludingSpace.forEach {
            remove(view: $0, animated: false)
            removeTapGesture(from: $0)
        }

        // These should theoretically be cleaned up from the remove methods,
        // but add in case of unexpected manipulation from caller
        timerMap.values.forEach {
            $0.invalidate()
        }
        timerMap = [UIView: Timer]()
        tapGestureMap = [UIView : UITapGestureRecognizer]()
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

extension UIImageView {
    
    /// Set the `UIImageView.image` and update `isHidden` by nullability of`image`
    func setImageAndHidden(_ image: UIImage?) {
        self.image = image
        isHidden = image == nil
    }
    
}

extension UILabel {
    
    /// Set the `UILabel.text` and update `isHidden` by nullability of `text`
    func setTextAndHidden(_ text: String?) {
        let labelText = text ?? ""
        self.text = text
        isHidden = labelText.isEmpty
    }
    
}

extension UIView {
    
    /// This is a default implemention of the `MessageConfigurable` protocol without actually
    /// implementing it.
    /// If we did implement it, then we would write an extension of `UIView` (a class) conforming to
    /// it, but we would not be able to override that behavior in subclasses as you can not override
    /// declarations in extensions.
    /// As we can not provide the code in the `UIView` base class (and override that), declare here.
    public func defaultApply(configuration: MessageConfiguration) {
        backgroundColor = configuration.backgroundColor
        tintColor = configuration.tintColor
        if configuration.shadow {
            addShadowBelow()
        } else {
            removeShadow()
        }
    }
}

// MARK: - MessageConfigurableView

/// Subclasses may inherit from this  and simply override the `MessageConfigurable` method if they wish.
/// Alternatively simply conform to `MessageConfigurable`
open class MessageConfigurableView: UIView, MessageConfigurable {
    open func apply(configuration: MessageConfiguration) {
        defaultApply(configuration: configuration)
    }
}


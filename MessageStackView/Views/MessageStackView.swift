//
//  MessageStackView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

/// Simply, a `UIStackView`, defined for type restriction
open class MessageStackView: UIStackView {
    
    /// Map `UIView` to a `Timer`s for removing that `UIView`s when it
    /// should only be around for a finite time
    private var timerMap = [UIView: Timer]()
    
    /// Map `UIView`s to their "tap to dismiss" `UITapGestureRecognizer`
    private var tapGestureMap = [UIView: UITapGestureRecognizer]()
    
    /// Map `UIView`s to their "pan to dismiss" `UIPanGestureRecognizer`
    private var panGestureMap = [UIView: UIPanGestureRecognizer]()
    
    /// Should the posted `UIView`s be handled by a serial queue, i.e. one at a time
    private var serialPostQueue: Bool = false
    
    /// `Queue` of `UIView`s to post when `serialPostQueue` is `true`
    private var postQueue: Queue<UIView> = Queue()
    
    /// `MessageStackViewDelegate`
    public weak var delegate: MessageStackViewDelegate?
    
    /// Default `MessageConfiguration` which describes the default
    /// look and feel of `MessageView`s.
    public var messageConfiguation = MessageConfiguration() {
        didSet {
            guard messageConfiguation.applyToAll else {
                return
            }
            
            // If the `messageConfiguation` has updated, update
            // the current `UIView`s
            arrangedSubviewsExcludingSpace.forEach {
                configure(view: $0)
            }
        }
    }
    
    // MARK: - Views
    
    /// This view is for smooth animations when there are no `arrangedSubviews`
    /// in the `UIStackView`.
    /// Otherwise the `UIStackView` can not determine it's width/height.
    /// With "no arranged subviews", we want to fix the width according to it's constraints,
    /// but have 0 height
    public lazy var spaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 0)
        ])
        return view
    }()
    
    // MARK: - Init
    
    /// Default initializer
    public convenience init() {
        self.init(arrangedSubviews: [])
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 0
        
        addArrangedSubview(spaceView)
    }
    
    /// Invalidate on deinit
    deinit {
        invalidate()
    }
    
    // MARK: - ArrangedSubviews
    
    /// `arrangedSubviews` excluding `spaceView`
    public var arrangedSubviewsExcludingSpace: [UIView] {
        return arrangedSubviews.filter { $0 != spaceView }
    }
    
    // MARK: - Invalidate
    
    /// Invalidate and remove timers
    public func invalidate() {
        arrangedSubviewsExcludingSpace.forEach {
            remove(view: $0, animated: false)
        }

        // These should theoretically be cleaned up from the remove methods,
        // but add in case of unexpected manipulation from caller
        timerMap.values.forEach {
            $0.invalidate()
        }
        timerMap = [UIView: Timer]()
        tapGestureMap = [UIView : UITapGestureRecognizer]()
        panGestureMap = [UIView : UIPanGestureRecognizer]()
    }
    
    // MARK: - Remove

    /// Remove `view` from `self`.
    ///
    /// - Note:
    /// Invalidates appropriate properties and checks if the `view`'s superview is `self`.
    /// If not, does nothing and simply returns.
    ///
    /// - Parameters:
    ///     - messageView: `UIView` to remove
    ///     - animated: Whether to animate the removal of the `messageView`
    ///
    /// - Returns: The `MessageView` created and added to the `messageStackView`
    public func remove(view: UIView, animated: Bool = true) {
        // Remove tap to dismiss gesture
        removeTapToRemoveGesture(from: view)
        
        // Remove pan to dismiss gesture
        removePanToRemoveGesture(from: view)
        
        // Remove pending removal timer
        timerMap[view]?.invalidate()
        timerMap[view] = nil
        
        // Ensure the context of the subview is still valid
        guard view.superview == self else {
            return
        }
        
        // Fire will remove
        self.delegate?.messageStackView(self, willRemove: view)
        
        // Execute remove wil animation if required
        guard animated else {
            completeRemove(view: view)
            return
        }
        
        layoutIfNeeded()
        UIView.animate(withDuration: .animationDuration, animations: {
            view.isHidden = true
            self.layoutIfNeeded()
        }) { finished in
            self.completeRemove(view: view)
        }
    }
    
    /// Remove from superview and send message to delegate
    /// - Parameter view: `UIView`
    private func completeRemove(view: UIView) {
        // Apple docs say the stackView will remove it from its
        // arrangedSubviews list automatically when calling this method
        view.removeFromSuperview()
        
        // Fire did remove
        self.delegate?.messageStackView(self, didRemove: view)
    }
    
    /// Post a `UIView`.
    ///
    /// - Note:
    /// This `view` will be added to a `fill` distributed `UIStackView` so it's width will
    /// be determined the `UIStackView`.
    /// However it's height should be determined by the `view` itself.
    /// E.g. intrinsicContentSize, autolayout, explicit height...
    ///
    /// - Parameters:
    ///     - view: A `UIView` to post
    ///     - dismissAfter: After how long after post should we dismiss `view`.
    ///       A value `<= 0` or `nil` will not start a timer to dismiss `view`.
    ///     - animated: Animate the posting of `view`
    public func post(
        view: UIView,
        dismissAfter: TimeInterval? = nil,
        animated: PostAnimation = .default
    ){
        // Time after post to dismiss, zero or `nil` to mean do not dismiss
        let dismissTimeInterval = max(0, dismissAfter ?? 0)
        
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
        guard dismissTimeInterval > 0 else {
            return
        }
        
        // Schedule timer to fire `remove` call
        timerMap[view] = Timer.scheduledTimer(
            withTimeInterval: dismissTimeInterval,
            repeats: false
        ) { [weak view, weak self] timer in
            if let view = view, let self = self {
                self.remove(view: view, animated: animated.contains(.onRemove))
            }
        }
    }
    
    // MARK: - Tap
    
    /// Add `UITapGestureRecognizer` to `view` to remove it from `self`
    /// - Parameter view: `UIView` to add gesture to
    public func addTapToRemoveGesture(to view: UIView) {
        guard tapGestureMap[view] == nil else {
            return
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureMap[view] = tap
        view.addGestureRecognizer(tap)
    }
    
    /// Remove `UITapGestureRecognizer` from `view`
    /// - Parameter view: `UIView` to remove gesture from
    public func removeTapToRemoveGesture(from view: UIView) {
        guard let tap = tapGestureMap[view] else {
            return
        }
        
        tapGestureMap[view] = nil
        view.removeGestureRecognizer(tap)
    }
    
    /// When a `UIView` wants to be dismissed on tap.
    /// - Parameter sender: `UITapGestureRecognizer`
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended, let view = sender.view else {
            return
        }
        remove(view: view, animated: true)
    }
    
    // MARK: - Pan
    
    // MARK: - Tap
    
    /// Add `UIPanGestureRecognizer` to `view` to remove it from `self`
    /// - Parameter view: `UIView` to add gesture to
    public func addPanToRemoveGesture(to view: UIView) {
        guard panGestureMap[view] == nil else {
            return
        }
        let tap = UIPanGestureRecognizer(target: self, action: #selector(viewPanned))
        panGestureMap[view] = tap
        view.addGestureRecognizer(tap)
    }
    
    /// Remove `UIPanGestureRecognizer` from `view`
    /// - Parameter view: `UIView` to remove gesture from
    public func removePanToRemoveGesture(from view: UIView) {
        guard let tap = panGestureMap[view] else {
            return
        }
        
        panGestureMap[view] = nil
        view.removeGestureRecognizer(tap)
    }
    
    /// When a `UIView` wants to be dismissed on pan.
    /// - Parameter sender: `UIPanGestureRecognizer`
    @objc private func viewPanned(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .ended, let view = sender.view else {
            return
        }
        remove(view: view, animated: true)
    }
    
    // MARK: - Layout
    
    /// Layout the `MessageStackView` with a common `MessafeLayout` use case.
    /// Custom layout is supported, simply add the `messageStackView` as a subview to a `UIView` and
    /// constrain it accordingly.
    public func addTo(_ layout: MessageLayout) {
        // Remove from previous layout tree if exists
        removeFromSuperview()
        
        // Constrain the `MessageStackView`
        layout.constrain(subview: self)
        
        // Prevent the first animation also positioning the `messageStackView`
        layout.view.setNeedsLayout()
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
}


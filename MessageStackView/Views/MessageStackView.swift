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
    
    /// Keep track of `Timer`s for removing `UIView`s that should only be around for a finite time
    var timerMap = [UIView: Timer]()
    
    /// Map `UIView`s to their "tap to dismiss" `UITapGestureRecognizer`
    var tapGestureMap = [UIView: UITapGestureRecognizer]()
    
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
        return arrangedSubviews.filter { $0 !== spaceView }
    }
    
    // MARK: - Invalidate
    
    /// Invalidate and remove timers
    public func invalidate() {
        arrangedSubviewsExcludingSpace.forEach {
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
    
    // MARK: - Tap
    
    /// Add `UITapGestureRecognizer`
    func addTapGesture(to view: UIView) {
        guard tapGestureMap[view] == nil else {
            return
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureMap[view] = tap
        view.addGestureRecognizer(tap)
    }
    
    /// Remove `UITapGestureRecognizer`
    func removeTapGesture(from view: UIView) {
        guard let tap = tapGestureMap[view] else {
            return
        }
        
        tapGestureMap[view] = nil
        view.removeGestureRecognizer(tap)
    }
    
    /// When a `UIView` wants to be dismissed on tap,
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
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

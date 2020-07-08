//
//  PostView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 07/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

/// `UIView` to post `UIView`s on a `PostManager` in a serial manner
open class PostView: UIView, Poster {
    
    /// Fixed constants for `PostView`
    private struct Constants {
        
        /// `UIEdgeInsets` to inset subviews relative to `self`
        static let edgeInsets = UIEdgeInsets(value: 10)
    }
    
    /// `PostManager` to manage posting, queueing, removing of `PostRequest`s
    public private(set) lazy var postManager: PostManager = {
        let postManager = PostManager(poster: self)
        postManager.isSerialQueue = true
        return postManager
    }()

    // MARK: - Init
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        clipsToBounds = true
    }
    
    // MARK: - IntrinsicContentSize
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 0)
    }
    
    // MARK: - Animation
    
    /// Show or hide a subview (`view`) based on the `hidden`argument.
    /// The transition may be animated.
    ///
    /// - Parameters:
    ///   - view: `UIView` subview
    ///   - hidden: `Bool` should the subview be hidden
    ///   - animated: `Bool` should the transition be animated
    ///   - completion: Closure to execute on completion of the animation if animated, or
    /// at the end of scope.
    private func setView(
        _ view: UIView,
        hidden: Bool,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        guard animated else {
            Self.setTransform(on: view, forHidden: hidden)
            completion()
            return
        }

        UIView.animate(
            withDuration: .animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.9,
            options: .curveEaseIn,
            animations: {
                Self.setTransform(on: view, forHidden: hidden)
        }) { _ in
            completion()
        }
    }
    
    // MARK: - Transform
    
    /// Consider "hidden" views as transformed out of the bounds above.
    /// With `clipsToBounds = true` these views will not be visible.
    /// We can then "show" them by animating their transform back to `.identity`
    ///
    /// - Parameters:
    ///   - view: `UIView` to set `transform` on
    ///   - hidden: Are we "hiding" the view
    private static func setTransform(on view: UIView, forHidden hidden: Bool) {
        view.transform = hidden ? hiddenTranslationY(for: view) : .identity
    }
    
    /// `CGAffineTransform` to effectively "hide" a view off the top of `self`'s `bounds`
    ///
    /// - Note:
    /// From the docs of `frame`:
    /// "If the transform property is not the identity transform, the value of this property is undefined
    /// and therefore should be ignored."
    ///
    /// - Parameter view: `UIView`
    private static func hiddenTranslationY(
        for view: UIView
    ) -> CGAffineTransform {
        return CGAffineTransform(
            translationX: 0,
            y: -(view.bounds.size.height + Constants.edgeInsets.top)
        )
    }
    
    // MARK: - Subview
    
    /// Add posted `subview`, constraining accordingly and ensuring `transform` for animation
    /// - Parameter subview: `UIView`
    private func addPostSubview(_ subview: UIView) {
        addSubview(subview)
        subview.edgeConstraints(to: self, insets: Constants.edgeInsets)
        layoutIfNeeded()
        
        Self.setTransform(on: subview, forHidden: true)
    }
    
    /// Remove a previously posted `subview` and ensure layout
    /// - Parameter subview: `UIView`
    private func removePostSubview(_ subview: UIView) {
        subview.removeFromSuperview()
        layoutIfNeeded()
    }
}

// MARK: - UIViewPoster

extension PostView: UIViewPoster {
    
    public func shouldRemove(view: UIView) -> Bool {
        return view.superview == self
    }
    
    public func post(
        view: UIView,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        // Add `view` as a posted subview
        addPostSubview(view)
        
        // Add pan gesture by default
        postManager.gestureManager.addPanToRemoveGesture(to: view)
        
        // Execute hide/show with animation if required
        setView(
            view,
            hidden: false,
            animated: animated,
            completion: completion
        )
    }
    
    public func remove(
        view: UIView,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        // Execute hide/show with animation if required
        setView(
            view,
            hidden: true,
            animated: animated,
            completion: {
                // Remove `view` as a posted subview
                self.removePostSubview(view)
                completion()
        })
    }
}

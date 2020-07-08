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
    
    private func setView(
        _ view: UIView,
        hidden: Bool,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        guard animated else {
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
                view.transform =
                    hidden ? Self.translationY(for: view) : .identity
        }) { _ in
            completion()
        }
    }
    
    /// From the docs of `frame`:
    /// "If the transform property is not the identity transform, the value of this property is undefined
    /// and therefore should be ignored."
    ///
    /// - Parameter view: `UIView`
    private static func translationY(for view: UIView) -> CGAffineTransform {
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
        
        subview.transform = Self.translationY(for: subview)
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
    
    /// Only remove if `self` is the `view.superview`
    /// - Parameter view: `UIView`
    public func shouldRemove(view: UIView) -> Bool {
        return view.superview == self
    }
    
    /// - Note:
    /// This `view` will be added to a `fill` distributed `UIStackView` so it's width will
    /// be determined the `UIStackView`.
    /// However it's height should be determined by the `view` itself.
    /// E.g. intrinsicContentSize, autolayout, explicit height...
    public func post(
        view: UIView,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        addPostSubview(view)
        
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
        setView(
            view,
            hidden: true,
            animated: animated,
            completion: {
                self.removePostSubview(view)
                completion()
        })
    }
}

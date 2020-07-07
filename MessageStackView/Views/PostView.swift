//
//  PostView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 07/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

open class PostView: UIView {
    
    /// `PostManager` to manage posting, queueing, removing of `PostRequest`s
    public private(set) lazy var postManager = PostManager(poster: self)
    
    private var topAnchorMap = [UIView : NSLayoutConstraint]()
    private var bottomAnchorMap = [UIView : NSLayoutConstraint]()
    
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
    
        layoutIfNeeded()
        UIView.animate(
            withDuration: .animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.15,
            options: .curveEaseIn,
            animations: {
                view.transform = hidden ? .translationY(for: view) : .identity
        }) { _ in
            completion()
            
        }

    }
}

private extension CGAffineTransform {
    
    static func translationY(for view: UIView) -> CGAffineTransform {
        return CGAffineTransform(
            translationX: 0,
            y: -view.bounds.size.height
        )
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
        addSubview(view)
        var edge = view.edgeConstraints(to: self)
        edge.insets = UIEdgeInsets(value: 10)
        layoutIfNeeded()
        view.transform = .translationY(for: view)
        
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
                view.removeFromSuperview()
                self.layoutIfNeeded()
                completion()
        })
    }
}

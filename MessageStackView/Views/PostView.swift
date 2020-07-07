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
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 0)
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
    
        UIView.animate(
            withDuration: .animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.9,
            options: .curveEaseIn,
            animations: {
                view.transform = hidden ?
                    .init(translationX: 0, y: -view.frame.maxY) :
                    .identity
        }) { _ in
            completion()
        }
    }
}

private extension CGAffineTransform {
    
    static func translationY(
        for view: UIView,
        inset: CGFloat
    ) -> CGAffineTransform {
        return CGAffineTransform(
            translationX: 0,
            y: -(view.bounds.size.height + inset)
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
        
        view.transform = .init(translationX: 0, y: -view.frame.maxY)
        
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

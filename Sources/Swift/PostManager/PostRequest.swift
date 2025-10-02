//
//  PostRequest.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// Request a `UIView` to be posted, its lifetime, and how the animation should behave
public struct PostRequest {

    /// A `UIView` to post
    public var view: UIView

    /// After how long after post should we dismiss `view`.
    /// A value `<= 0` or `nil` will not start a timer to dismiss `view`.
    public var dismissAfter: TimeInterval?

    /// Animate the posting of `view`
    public var animated: PostAnimation

    /// Default public memberwise initializer
    /// - Parameters:
    ///   - view: `UIView`
    ///   - dismissAfter: `TimInterval?`
    ///   - animated: `PostAnimation`
    public init (
        view: UIView,
        dismissAfter: TimeInterval? = nil,
        animated: PostAnimation = .both
    ) {
        self.view = view
        self.dismissAfter = dismissAfter
        self.animated = animated
    }
}

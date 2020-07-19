//
//  Poster.swift
//  MessageStackView
//
//  Created by Ben Shutt on 08/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// Entity with a `PostManager`
public protocol Poster {
    
    /// Has reference to a `PostManager`
    var postManager: PostManager { get }
}

// MARK: - Poster + UIView

public extension Poster {
    
    /// Post `view`, `dismissAfter`, `animated` onto the `postManager`
    /// - Parameters:
    ///   - view: `UIView`
    ///   - dismissAfter: `TimerInterval?`
    ///   - animated: `PostAnimation`
    func post(
        view: UIView,
        dismissAfter: TimeInterval? = .defaultDismiss,
        animated: PostAnimation = .default
    ){
        postManager.post(postRequest: PostRequest(
            view: view,
            dismissAfter: dismissAfter,
            animated: animated
        ))
    }
}

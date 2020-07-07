//
//  BadgeMessagePostView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 07/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

public extension PostView {
    
    /// Post a `badgeMessage`
    ///
    /// - Parameters:
    ///   - badgeMessage: `BadgeMessage`
    ///   - dismissAfter: `TimeInterval?`
    ///   - animated: `PostAnimation`
    @discardableResult
    func post(
        badgeMessage: BadgeMessage,
        dismissAfter: TimeInterval? = 5,
        animated: PostAnimation = .both
    ) -> BadgeMessageView {
        let badgeMessageView = BadgeMessageView()
        badgeMessageView.set(badgeMessage: badgeMessage)
        
        postManager.post(postRequest: PostRequest(
            view: badgeMessageView,
            dismissAfter: dismissAfter,
            animated: animated
        ))
        
        return badgeMessageView
    }
}

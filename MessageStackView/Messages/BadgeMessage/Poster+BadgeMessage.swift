//
//  BadgeMessagePostView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 07/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

public extension Poster {
    
    /// Post a `badgeMessage`
    ///
    /// - Parameters:
    ///   - badgeMessage: `BadgeMessage`
    ///   - dismissAfter: `TimeInterval?`
    ///   - animated: `PostAnimation`
    @discardableResult
    func post(
        badgeMessage: BadgeMessage,
        dismissAfter: TimeInterval? = .defaultMessageDismiss,
        animated: PostAnimation = .both
    ) -> BadgeMessageView {
        
        // Create a `BadgeMessageView`
        let badgeMessageView = BadgeMessageView()
        
        // Apply `badgeMessage`
        badgeMessageView.set(badgeMessage: badgeMessage)
        
        // Post the view
        postManager.post(postRequest: PostRequest(
            view: badgeMessageView,
            dismissAfter: dismissAfter,
            animated: animated
        ))
        
        return badgeMessageView
    }
}

//
//  PostAnimation.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

/// Alow the caller to control the animation when posting a message
public struct PostAnimation: OptionSet {
    public let rawValue: Int
    
    /// Override access modifier to public
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Animate only on post
    public static let onPost = PostAnimation(rawValue: 1 << 0)
    
    /// Animate only on remove
    public static let onRemove = PostAnimation(rawValue: 1 << 1)
    
    /// Animate both on post and remove
    public static let both: PostAnimation = [.onPost, .onRemove]
    
    /// Don't animate on either post or remove
    public static let none: PostAnimation = []
}

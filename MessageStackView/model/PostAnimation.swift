//
//  PostAnimation.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

/// Alow the caller to control the animation when posting a message
public enum PostAnimation: Int
{
    /// Animate both on post and on remove
    case both
    
    /// Animate only on post
    case onPost
    
    /// Animate only on remove
    case onRemove
    
    /// Do not animate on either post or remove
    case none
    
    /// Helper to check if we should animate on post
    var animateOnPost: Bool {
        return self == .both || self == .onPost
    }
    
    /// Helper to check if we should animate on remove
    var animateOnRemove: Bool {
        return self == .both || self == .onRemove
    }
}

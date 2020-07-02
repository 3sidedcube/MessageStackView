//
//  Message.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

/// Message model to post
public struct Message {
    
    /// Title of the message
    public var title: String
    
    /// Subtitle of the message
    public var subtitle: String? = nil
    
    /// Left `UIImage` of the message
    public var leftImage: UIImage? = nil
    
    /// Right `UIImage` of the message
    public var rightImage: UIImage? = nil
    
    /// Default public memberwise initializer.
    /// - Parameters:
    ///   - title: `String` title of the message
    ///   - subtitle: `String` subtitle of the message
    ///   - leftImage: `UIImage` on left
    ///   - rightImage: `UIImage` on right
    public init(
        title: String,
        subtitle: String? = nil,
        leftImage: UIImage? = nil,
        rightImage: UIImage? = nil
    ){
        self.title = title
        self.subtitle = subtitle
        self.leftImage = leftImage
        self.rightImage = rightImage
    }
}

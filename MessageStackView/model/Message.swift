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
    
    /// Public default memberwise initializer.
    /// Definition required for public in framework, otherwise defaults to internal (unless there is a private var in which
    /// case it would be private).
    public init(title: String, subtitle: String? = nil, leftImage: UIImage? = nil, rightImage: UIImage? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.leftImage = leftImage
        self.rightImage = rightImage
    }
}

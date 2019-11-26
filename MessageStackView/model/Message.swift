//
//  Message.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

/// Message model to post
public struct Message
{
    /// Title of the message
    public var title: String
    
    /// Subtitle of the message
    public var subtitle: String? = nil
    
    /// `UIImage` of the message
    public var image: UIImage? = nil
    
    /// Public default memberwise initializer.
    /// Definition required for public in framework, otherwise defaults to internal (unless there is a private var in which
    /// case it would be private).
    public init(title: String, subtitle: String? = nil, image: UIImage? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}

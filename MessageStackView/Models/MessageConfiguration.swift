//
//  MessageConfiguration.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

/// Define a default configuration to messages look and feel
public struct MessageConfiguration {
    
    /// Background color of `MessageView`s
    public var backgroundColor: UIColor = MessageConfiguration.defaultBackgroundColor
    
    /// Tint color of `MessageView`s
    public var tintColor: UIColor = MessageConfiguration.defaultTintColor
    
    /// If shadow is added below `MessageView`
    public var shadow: Bool = true
    
    /// If this configuration updates, should previously posted `MessageView`s be updated
    public var applyToAll: Bool = false
    
    /// Public default memberwise initializer.
    public init(
        backgroundColor: UIColor = MessageConfiguration.defaultBackgroundColor,
        tintColor: UIColor = MessageConfiguration.defaultTintColor,
        shadow: Bool = true,
        applyToAll: Bool = false
    ){
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.shadow = shadow
        self.applyToAll = applyToAll
    }
    
    // MARK: - Constants
    
    /// Default background color of a `MessageView`
    public static let defaultBackgroundColor = UIColor(
        red255: 245, green255: 245, blue255: 245
    )
    
    /// Default tint color of a `MessageView`
    public static let defaultTintColor: UIColor = .darkGray
}

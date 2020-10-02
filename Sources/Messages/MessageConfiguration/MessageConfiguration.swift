//
//  MessageConfiguration.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

/// Define a default configuration to look and feel
public struct MessageConfiguration {
    
    /// A standard/default `MessageConfiguration`
    public static var `default` = MessageConfiguration(
        backgroundColor: .defaultBackgroundColor,
        tintColor: .defaultTintColor,
        shadow: true,
        applyToAll: false
    )
    
    /// Background color of `MessageView`s
    public var backgroundColor: UIColor?
    
    /// Tint color of `MessageView`s
    public var tintColor: UIColor?
    
    /// If shadow is added below `MessageView`
    public var shadow: Bool
    
    /// If this configuration updates, should previously posted `MessageView`s be updated
    public var applyToAll: Bool
    
    /// Public default memberwise initializer.
    /// - Parameters:
    ///   - backgroundColor: `UIColor`
    ///   - tintColor: `UIColor`
    ///   - shadow: `Bool`
    ///   - applyToAll: `Bool`
    public init(
        backgroundColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        shadow: Bool = false,
        applyToAll: Bool = false
    ){
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.shadow = shadow
        self.applyToAll = applyToAll
    }
}

// MARK: - MessageConfiguration + UIColor

public extension UIColor {
    
    /// Default background color of a `MessageView`
    static let defaultBackgroundColor = UIColor(
        red255: 245, green255: 245, blue255: 245
    )
    
    /// Default tint color of a `MessageView`
    static let defaultTintColor: UIColor = .darkGray
}

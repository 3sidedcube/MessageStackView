//
//  MessageConfiguration.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

public struct MessageConfiguration
{
    /// Background color of `MessageView`s
    public var backgroundColor: UIColor = .defaultBackgroundColor
    
    /// Tint color of `MessageView`s
    public var tintColor: UIColor = .defaultTintColor
    
    /// If shadow is added below `MessageView`
    public var shadow: Bool = true
    
    /// If this configuration updates, should previously posted messageViews be updated
    public var applyToAll = false
}

fileprivate extension UIColor {
    
    /// Default background color of a `MessageView`
    static let defaultBackgroundColor = UIColor(red255: 245, green: 245, blue: 245)
    
    /// Default tint color of a `MessageView`
    static let defaultTintColor: UIColor = .darkGray
}

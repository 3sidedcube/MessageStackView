//
//  UIView+MessageConfiguration.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// This is a default implemention of the `MessageConfigurable` protocol without actually
    /// implementing it.
    /// If we did implement it, then we would write an extension of `UIView` (a class) conforming to
    /// it, but we would not be able to override that behavior in subclasses as you can not override
    /// declarations in extensions.
    /// As we can not provide the code in the `UIView` base class (and override that), declare here.
    public func defaultApply(configuration: MessageConfiguration) {
        // backgroundColor
        backgroundColor = configuration.backgroundColor
        
        // tintColor
        tintColor = configuration.tintColor
        
        // shadow
        if configuration.shadow {
            addShadowBelow()
        } else {
            removeShadow()
        }
    }
}

extension UIView: MessageConfigurable {
    
    /// Apply `configuration`
    /// - Parameter configuration: `MessageConfiguration
    public func apply(configuration: MessageConfiguration) {
        defaultApply(configuration: configuration)
    }
}

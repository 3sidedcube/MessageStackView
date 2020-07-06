//
//  UIView+MessageConfiguration.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

extension UIView: MessageConfigurable {
    
    /// Apply a `MessageConfiguration`
    /// - Parameter configuration: `MessageConfiguration`
    public func apply(configuration: MessageConfiguration) {
        
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

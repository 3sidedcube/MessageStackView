//
//  Message+MessageConfigurable.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

extension MessageView: MessageConfigurable {
    
    /// Apply a `MessageConfiguration`
    /// - Parameter configuration: `MessageConfiguration`
    public func set(configuration: MessageConfiguration) {
        
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

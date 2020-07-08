//
//  MSVTapGesture.swift
//  MessageStackView
//
//  Created by Ben Shutt on 04/12/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

/// Apply a `MessageConfiguration`
public protocol MessageConfigurable {
    
    /// Allow a `MessageConfiguration` to be applied
    ///
    /// - Parameter configuration: The `MessageConfiguration`
    func set(configuration: MessageConfiguration)
}

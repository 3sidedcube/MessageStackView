//
//  Constrainable.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// Entity which has an Array of `NSLayoutConstraint`s
protocol Constrainable {

    /// Array of `NSLayoutConstraint`s to activate
    var constraints: [NSLayoutConstraint] { get }
}

// MARK: - Constrainable + Extensions

extension Constrainable {

    /// Activate `constraints`
    func activate() {
        NSLayoutConstraint.activate(constraints)
    }
}

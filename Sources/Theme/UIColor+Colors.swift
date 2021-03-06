//
//  UIColor+Colors.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// Custom `UIColor`s used in the framework
extension UIColor {

    /// Theme red color
    static let themeRed = UIColor(red255: 231, green255: 19, blue255: 36)

    /// Theme dark gray color
    static let themeDarkGray = UIColor(red255: 109, green255: 110, blue255: 112)

    /// Shadow color
    static let shadowGray = UIColor(red255: 63, green255: 63, blue255: 63)

    /// First part of neomorphic shadow
    static let neomorphicGray1 = UIColor(red255: 149, green255: 150, blue255: 177)

    /// Second part of neomorphic shadow
    static let neomorphicGray2 = UIColor(red255: 143, green255: 147, blue255: 150)
}

// MARK: - UIColor + RGB-255

extension UIColor {

    /// Shorthand to create colors using 255 notation
    ///
    /// - Parameters:
    ///   - red: Red value in [0, 255]
    ///   - green: Green value in [0, 255]
    ///   - blue: Blue value in [0, 255]
    ///   - alpha: Alpha value in [0, 1]
    convenience init(
        red255 red: CGFloat,
        green255 green: CGFloat,
        blue255 blue: CGFloat,
        alpha: CGFloat = 1
    ) {
        self.init(
            red: red / 255,
            green: green / 255,
            blue: blue / 255,
            alpha: alpha
        )
    }
}

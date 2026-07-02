//
//  UIColor+Hex.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    /// Red, green, blue alpha color components.
    /// Components in the range [0, 1]
    struct RGBA {

        /// Red component
        var red: CGFloat

        /// Green component
        var green: CGFloat

        /// Blue component
        var blue: CGFloat

        /// alpha component
        var alpha: CGFloat
    }

    /// Shorthand for creating a `UIColor` with RGBA ranges in [0, 255].
    ///
    /// - Note:
    /// Named consistently with `init(displayP3Red:green:blue:alpha:)`
    ///
    /// - Parameters:
    ///   - red: Red component in [0, 255]
    ///   - green: Green component in [0, 255]
    ///   - blue: Blue component in [0, 255]
    ///   - alpha: Alpha component in [0, 255]
    convenience init(
        red255 red: CGFloat,
        green: CGFloat,
        blue: CGFloat,
        alpha: CGFloat = 255
    ) {
        self.init(
            red: red / 255,
            green: green / 255,
            blue: blue / 255,
            alpha: alpha / 255
        )
    }

    /// Shorthand for creating a `UIColor` with white in [0, 255].
    ///
    /// - Parameters:
    ///   - white: White component in [0, 255]
    ///   - alpha: Alpha component in [0, 255]
    convenience init(
        white255 white: CGFloat,
        alpha: CGFloat = 255
    ) {
        self.init(
            white: white / 255,
            alpha: alpha / 255
        )
    }

    // MARK: - Hex

    /// Initialize `UIColor` with the given HEX `string`.
    ///
    /// The `string` can be of the form:
    /// - RGB (12-bit)
    /// - RGB (24-bit)
    /// - RGBA (32-bit)
    ///
    /// - Parameter string: `String` hex formatted color
    convenience init? (hexString string: String) {
        let notAlphaNumerics = CharacterSet.alphanumerics.inverted
        let hex = string.trimmingCharacters(in: notAlphaNumerics)

        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = (
                (int >> 8) * 17, // r
                (int >> 4 & 0xF) * 17, // g
                (int & 0xF) * 17, // b
                255 // a
            )
        case 6: // RGB (24-bit)
            (r, g, b, a) = (
                int >> 16, // r
                int >> 8 & 0xFF, // g
                int & 0xFF, // b
                255 // a
            )
        case 8: // RGBA (32-bit)
            (r, g, b, a) = (
                int >> 24, // r
                int >> 16 & 0xFF, // g
                int >> 8 & 0xFF, // b
                int & 0xFF // a
            )
        default:
            return nil
        }

        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }

    /// Get `RGBA` components from `UIColor`
    var rgba: RGBA {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// `UIColor` to RGB HEX `String`
    ///
    /// - Parameter includeAlpha: Include the alpha
    func hexString(includeAlpha: Bool = true) -> String {
        let rgba = self.rgba

        var hex = String(
            format: "#%02X%02X%02X",
            Int(round(rgba.red * 255)),
            Int(round(rgba.green * 255)),
            Int(round(rgba.blue * 255))
        )

        if includeAlpha {
            hex += String(format: "%02X", Int(round(rgba.alpha * 255)))
        }

        return hex
    }
}

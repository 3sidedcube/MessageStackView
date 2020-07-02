//
//  UIColor+Extensions.swift
//  MessageStackView
//
//  Created by Ben Shutt on 25/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

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
            red: red/255,
            green: green/255,
            blue: blue/255,
            alpha: alpha
        )
    }
}


//
//  Double+Equals.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

extension FloatingPoint {
    
    /// Is equal to `other` within precision of `epsilon`
    ///
    /// - Parameters:
    ///   - other: `Self` Another value
    ///   - epsilon: `Self` Precision
    func isFloatingPointEqual(
        to other: Self,
        withPrecision epsilon: Self = .ulpOfOne
    ) -> Bool {
        return abs(self - other) < epsilon
    }
}

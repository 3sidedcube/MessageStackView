//
//  Function.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/03/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// A single variable function `f: X -> Y`
protocol Function {
    associatedtype ValueType: FloatingPoint

    /// Let `f: X -> Y` be a function over `X` mapping to `Y`.
    /// For a given `x` in `X` return `f(x)` in `Y`.
    /// `X` is defined as the domain of `f`.
    /// `Y` is defined as the range of `f`.
    /// - Parameter x: `x` in `X`, the domain of `f`
    /// - Returns: `f(x)` in `Y`, the range of `f`
    func value(for x: ValueType) -> ValueType
}


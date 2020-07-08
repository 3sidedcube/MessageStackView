//
//  ScaleFunction.swift
//  Animation
//
//  Created by Ben Shutt on 03/03/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation

/// Let `f(x) = m * x + c` be a linear function.
/// We define a behavior such that
/// - `f(0) = 1`
/// - `f(T) = Y`
/// for a `T` (in the domain) where our function `f` attains `Y` (in the range).
///
/// Common use case would be scaling (e.g. transform) from 1 (at zero) to some scale (`Y`)
/// over a time (`T`).
struct ScaleFunction: Function {
    typealias ValueType = TimeInterval
    
    /// Value in the domain where the `Function` attains `Y`
    let T: ValueType
    
    /// Value in the range to attain.
    /// E.g. a scale after a given time
    let Y: ValueType
    
    /// Default memberwise initializer
    /// - Parameters:
    ///   - T: `ValueType`
    ///   - Y: `ValueType`
    public init(
        T: ValueType,
        Y: ValueType
    ){
        self.T = T
        self.Y = Y
    }
    
    /// Gradient of linear function
    var m: ValueType {
        return (Y - 1) / T
    }
    
    /// Value of linear function at `0`
    var c: ValueType {
        return 1
    }
    
    // MARK: - Function
    
    func value(for x: ValueType) -> ValueType {
        return m * x + c
    }
}

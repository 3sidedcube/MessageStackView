//
//  ShakeFunction.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/03/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// Define:
/// `f(x) = alpha * x * x * sin(2 * pi * x / C)`
/// Let `T` =  `"Max x"` where time should end.
/// Define `N` such that, `N` is a positive integer `> 0` and `NC = T`
/// where `C` is the duration of each cycle (cycle where `sin` repeats).
/// Set `Y` such that `f(T) "attains" Y` if not for the `sin` factor.
/// That is: `alpha * T * T = Y`
struct ShakeFunction: Function {
    typealias ValueType = TimeInterval

    /// Time to acquire maximum function value
    let T: ValueType

    /// Maximum function value
    let Y: ValueType

    /// A `sin(x)` curve repeats after a given cycle, define the number of cycles before `T`
    let N: Int

    init(
        T: ValueType,
        Y: ValueType,
        N: Int
    ) {
        self.T = T
        self.Y = Y
        self.N = N
    }

    /// Function scale factor
    var alpha: Double {
        return Y / (T * T)
    }

    /// Cycle time
    var C: TimeInterval {
        return T / TimeInterval(N)
    }

    // MARK: - Function

    func value(for x: Double) -> Double {
        return alpha * x * x * sin(2 * Double.pi * x / C)
    }
}

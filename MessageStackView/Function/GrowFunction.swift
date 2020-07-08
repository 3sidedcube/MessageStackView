//
//  GrowFunction.swift
//  Animation
//
//  Created by Ben Shutt on 04/03/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

/// `f(x) = M(1 - exp(-alpha * x))`
/// `f -> M` as `x -> inf` for `alpha > 0`
/// `f(0) = 0`
/// At `x = X - xDelta` `f(x) = M - yDelta`.
/// `xDelta`, `yDelta` defined as "close to" their respective values.
/// Use case `x` in `[0, X]`
struct GrowFunction: Function {
    typealias ValueType = CGFloat
    
    /// Asymptotic value as `f` converges on `inf`
    let M: CGFloat = 1
    
    /// Approximate "end" for domain, `x in [0, X]`
    let X: CGFloat = 1
    
    /// Alpha exponential scale factor
    private var alpha: CGFloat {
        
        // The delta from `X` to attain delta of `M` ("close to `M`")
        let xDelta: ValueType = 0.1
        let x = X - xDelta
        
        // The delta from `M` at `x` (`f(x) = M - yDelta`)
        let yDelta: ValueType = 0.01
        
        return (-1 / x) * log(yDelta / M)
    }
    
    // MARK: - Function
    
    /// `f(x) = M(1 - exp(-alpha * x))`
    /// - Parameter x: `x` in the domain of `f`
    func value(for x: CGFloat) -> CGFloat {
        return M * (1 - exp(-alpha * x))
    }
}

//
//  ScaleFunction.swift
//  Animation
//
//  Created by Ben Shutt on 03/03/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation

struct ScaleFunction {
    typealias ValueType = TimeInterval
    
    let T: ValueType
    
    let Y: ValueType
    
    public init(
        T: ValueType,
        Y: ValueType
    ){
        self.T = T
        self.Y = Y
    }
    
    var m: ValueType {
        return (Y - 1) / T
    }
    
    var C: ValueType {
        return 1
    }
    
    // MARK: - Function
    
    func value(for x: ValueType) -> ValueType {
        return m * x + C
    }
}

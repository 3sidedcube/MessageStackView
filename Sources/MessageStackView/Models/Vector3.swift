//
//  Vector3.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/10/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// 3 dimensional vector with values in X, Y, and Z
struct Vector3<Element> where Element: FloatingPoint {

    /// X coordinate value
    var x: Element

    /// Y coordinate value
    var y: Element

    /// Z coordinate value
    var z: Element
}

// MARK: - Equatable

extension Vector3: Equatable {}

// MARK: - Hashable

extension Vector3: Hashable {}

// MARK: - Codable

extension Vector3: Codable where Element: Codable {}

// MARK: - CustomStringConvertible

extension Vector3: CustomStringConvertible {
    var description: String {
        return "(\(x),\(y),\(z))"
    }
}

// MARK: - AdditiveArithmetic

extension Vector3: AdditiveArithmetic {

    static var zero: Vector3 {
        return Vector3(x: 0, y: 0, z: 0)
    }

    static func + (lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y,
            z: lhs.z + rhs.z
        )
    }

    static func - (lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(
            x: lhs.x - rhs.x,
            y: lhs.y - rhs.y,
            z: lhs.z - rhs.z
        )
    }
}

// MARK: - Extensions

extension Vector3 {

    /// `Array<Element>` for `x`, `y`, `z`
    var array: [Element] {
        return [x, y, z]
    }
}

//
//  CALayer+Animation.swift
//  MessageStackView
//
//  Created by Ben Shutt on 27/06/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

// MARK: - CALayer

extension CALayer {

    /// Animate transform from `from` to `to`
    /// - Parameters:
    ///   - duration: Animation duration
    ///   - from: Start state
    ///   - to: End state
    func transformAnimation(
        duration: TimeInterval,
        from: Vector3<CGFloat> = .zero,
        to: Vector3<CGFloat> = Vector3(x: 1, y: 1, z: 1)
    ) -> CABasicAnimation {

        let keyPath = #keyPath(transform)
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.duration = duration
        animation.valueFunction = CAValueFunction(name: .scale)
        animation.fromValue = from.array
        animation.toValue = to.array
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        // Change the actual data value in the layer to the final value.
        transform = CATransform3DScale(transform, to.x, to.y, to.z)

        return animation
    }

    /// Animate opacity from `from` to `to`
    /// - Parameters:
    ///   - duration: Animation duration
    ///   - from: Start state
    ///   - to: End state
    func opacityAnimation(
        duration: TimeInterval,
        from: Float = 0,
        to: Float = 1
    ) -> CABasicAnimation {

        let keyPath = #keyPath(opacity)
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.duration = duration
        animation.fromValue = from
        animation.toValue = to

        // Change the actual data value in the layer to the final value.
        opacity = to

        return animation
    }
}

//
//  UIView+Animation.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// Transform `self` in `x` and `y` by the given `scale`
    /// - Parameters:
    ///   - scale: Transform scale
    ///   - duration: Duration of the animation
    ///   - completion: Completion block to execute
    func pulse(
        scale: CGFloat = 1.1,
        duration: TimeInterval = 0.5,
        completion: ((Bool) -> Void)? = nil
    ) {
        let from = Vector3<CGFloat>(x: 1, y: 1, z: 1)
        let to = Vector3(x: scale, y: scale, z: scale)
        let animation = layer.transformAnimation(
            duration: duration,
            from: from,
            to: to
        )
        animation.autoreverses = true
        animation.repeatCount = 1
        layer.transform = CATransform3DIdentity // Reset back to identity matrix
        layer.add(animation, forKey: #keyPath(layer.transform))
    }
}


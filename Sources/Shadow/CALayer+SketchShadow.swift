//
//  CALayer+SketchShadow.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// Model based on Sketch properties.
struct SketchShadow {
    
    /// Shadow color
    var color: UIColor
    
    /// Shadow opacity
    var alpha: Float
    
    /// Shadow offset in x
    var x: CGFloat
    
    /// Shadow offset in y
    var y: CGFloat
    
    /// Shadow blur (2 * shadow radius)
    var blur: CGFloat
    
    /// Shadow spread
    var spread: CGFloat
}

// MARK: - ShadowComponents + SketchShadow

extension ShadowComponents {
    
    /// `ShadowComponents` to `SketchShadow`
    var sketchShadow: SketchShadow {
        return SketchShadow(
            color: color,
            alpha: opacity,
            x: offset.width,
            y: offset.height,
            blur: radius * 2,
            spread: 0
        )
    }
}

// MARK: - CALayer + SketchShadow

extension CALayer {
    
    /// Apply `sketchShadow` to `CALayer`
    ///
    /// - Warning:
    /// This function sets the `shadowPath` based on the `bounds` of the layer
    ///
    /// - Parameter sketchShadow: `SketchShadow`
    func setSketchShadow(_ sketchShadow: SketchShadow) {
        shadowColor = sketchShadow.color.cgColor
        shadowOpacity = sketchShadow.alpha
        shadowOffset = CGSize(width: sketchShadow.x, height: sketchShadow.y)
        shadowRadius = sketchShadow.blur * 0.5
        if sketchShadow.spread == 0 {
            shadowPath = nil
        } else {
            let dx = -sketchShadow.spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(
                roundedRect: rect,
                cornerRadius: cornerRadius
            ).cgPath
        }
    }
}

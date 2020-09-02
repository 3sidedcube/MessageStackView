//
//  ShadowView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/09/2020.
//  Credit to Simon Mitchell for the core functionality of this file.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView + Shadow

public extension UIView {
    
    /// Set a Neuomorphic Shadow on the `UIView` instance
    /// - Parameter corner: `Corner`
    func setNeuomorphicShadow() {
        setShadowComponents([
            .init(
                radius: 2,
                opacity: 0.05,
                color: .shadowGray,
                offset: .init(width: 0, height: 1)
            ),
            .init(
                radius: 2,
                opacity: 0.03,
                color: .shadowGray,
                offset: .init(width: 0, height: -1)
            ),
            .init(
                radius: 8,
                opacity: 0.05,
                color: .shadowGray,
                offset: .init(width: 0, height: 2)
            )
        ])
    }
    
    /// Remove sublayers of type `ShadowLayer`
    func removeShadowLayers() {
        layer.forEachShadowLayer { $0.removeFromSuperlayer() }
    }
    
    
    /// Add `ShadowLayer` sublayers mapped by the given `components`
    ///
    /// - Parameters:
    ///   - components:
    ///   `[ShadowComponents]` to map to `ShadowLayer`s
    ///
    ///   - createSubview:
    ///   If `true`, add `ShadowLayer`s to the first `ShadowView` subview's `layer`.
    ///   If the `ShadowView` doesn't exist, create and add as a subview at the root subview index.
    ///   This allows for setting an `autoresizingMask`.
    ///   If `false` then the `ShadowLayer`s are added to `self`'s `layer`.
    func setShadowComponents(
        _ components: [ShadowComponents],
        createSubview: Bool = true
    ) {
        // view to add shadow layers tos
        var view = self
        
        // If `createSubview`, find or create a `ShadowView` to add the
        // shadow layers to.
        // Setting this to `true` allows setting an `autoresizingMask`
        if createSubview {
            var shadowView: ShadowView! = firstSubviewOfType()
            if shadowView == nil {
                shadowView = ShadowView(frame: bounds)
                shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                insertSubview(shadowView, at: 0)
            }
            view = shadowView
        }
        
        view.removeShadowLayers()
        
        components.forEach {
            let shadowLayer = ShadowLayer(shadowComponents: $0)
            view.layer.insertSublayer(shadowLayer, at: 0)
            shadowLayer.superlayerDidUpdate()
        }
    }
}

// MARK: - NeuomorphicShadowView

/// A subclass of `UIView` which sets the layer to `ParentShadowLayer` which
/// manages `ShadowLayer` sublayers
public class ShadowView: UIView {
    
    public override class var layerClass: AnyClass {
        return ParentShadowLayer.self
    }
}

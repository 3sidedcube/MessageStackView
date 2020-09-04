//
//  UIView+ShadowLayer.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    /// Set a Neuomorphic Shadow on the `UIView` instance
    ///
    /// - Parameters:
    ///   - shadow: `NeuomorphicShadow`
    ///   - createSubview: `Bool`
    func setNeuomorphicShadow(
        _ shadow: NeuomorphicShadow = .center,
        createSubview: Bool = false
    ) {
        setShadowComponents(shadow.components, createSubview: createSubview)
    }
    
    /// Remove sublayers of type `ShadowLayer`
    func removeShadowLayers() {
        layer.forEachShadowLayer {
            $0.removeFromSuperlayer()
        }
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
    ///
    /// - Warning:
    /// This is recommended to be called on a `ShadowView`.
    /// Otherwise this needs to be recalled everytime a layer corner property updates.
    /// Setting `createSubview` to `true` will ensure the `frame` of the subayers are updated
    /// by adding a `ShadowView` subview (if required) with an `autoresizingMask`.
    /// Otherwise this also needs to be recalled when the `frame` changes.
    func setShadowComponents(
        _ components: [ShadowComponents],
        createSubview: Bool = false
    ) {
        // view to add `ShadowLayer`s to
        var view = self
        
        // If `createSubview`, find or create a `ShadowView` to add the
        // `ShadowLayer`s to.
        // Setting this to `true` allows setting an `autoresizingMask`
        if createSubview {
            var shadowView: ShadowView! = firstSubviewOfType(includeSelf: true)
            if shadowView == nil {
                shadowView = ShadowView(frame: bounds)
                shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                insertSubview(shadowView, at: 0)
            }
            view = shadowView
            
            if shadowView != self {
                // Copy shadow relevant properties of superlayer to new
                // shadowView subview
                shadowView.layer.copySuperlayerPropertiesForShadow()
            }
        }
        
        // Remove `ShadowLayer`s
        view.removeShadowLayers()
        
        // Add `ShadowLayer`s
        components.forEach {
            let shadowLayer = ShadowLayer()
            view.layer.insertSublayer(shadowLayer, at: 0)
            shadowLayer.copySuperlayerPropertiesForShadow()
            shadowLayer.shadowComponents = $0
        }
    }
}

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
    
    func removeShadowLayers() {
        layer.forEachShadowLayer { $0.removeFromSuperlayer() }
    }
    
    func setShadowComponents(_ components: [ShadowComponents]) {
        removeShadowLayers()
        
        components.forEach {
            let shadowLayer = ShadowLayer(shadowComponents: $0)
            layer.insertSublayer(shadowLayer, at: 0)
            shadowLayer.superLayerDidUpdate()
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

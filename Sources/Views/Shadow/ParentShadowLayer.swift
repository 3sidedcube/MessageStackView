//
//  ParentShadowLayer.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// `ParentShadowLayer` for sublayer `ShadowLayer`s
///
/// - Note:
/// This is required to handle the relevant lifecycle/observable methods onto the
/// `ShadowLayer` sublayers.
///
///
public class ParentShadowLayer: CALayer {
    
    // MARK: - Observable Properties
    
    @available(iOS 13, *)
    public override var cornerCurve: CALayerCornerCurve {
        didSet {
            forEachShadowLayer {
                $0.cornerCurve = cornerCurve
            }
        }
    }
    
    public override var cornerRadius: CGFloat {
        didSet {
            forEachShadowLayer {
                $0.cornerRadius = cornerRadius
            }
        }
    }
    
    public override var backgroundColor: CGColor? {
        didSet {
            forEachShadowLayer {
                $0.backgroundColor = backgroundColor
            }
        }
    }
    
    // MARK: - Layout
    
    public override func layoutSublayers() {
        super.layoutSublayers()
        
        forEachShadowLayer {
            $0.frame = bounds
        }
    }
}

// MARK: - CALayer + ShadowLayer

extension CALayer {
    
    func removeShadowLayers() {
        forEachShadowLayer { $0.removeFromSuperlayer() }
    }
    
    /// Iterate sublayers of type `ShadowLayer`
    /// - Parameter closure: Closure to execute
    func forEachSublayer<T>(
        _ closure: (T) -> Void
    ) where T: CALayer {
        sublayers?
            .compactMap { $0 as? T }
            .forEach { closure($0) }
    }
    
    /// Iterate sublayers of type `ShadowLayer`
    /// - Parameter closure: Closure to execute
    func forEachShadowLayer(_ closure: (ShadowLayer) -> Void) {
        forEachSublayer(closure)
    }
}

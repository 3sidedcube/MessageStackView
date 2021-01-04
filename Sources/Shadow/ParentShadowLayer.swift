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
open class ParentShadowLayer: CALayer {

    // MARK: - Init

    override public init() {
        super.init()
        setup()
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        masksToBounds = false
        backgroundColor = UIColor.clear.cgColor
    }

    // MARK: - Observable Properties

    @available(iOS 13, *)
    override public var cornerCurve: CALayerCornerCurve {
        didSet {
            forEachShadowLayer {
                $0.cornerCurve = cornerCurve
            }
        }
    }

    override public var cornerRadius: CGFloat {
        didSet {
            forEachShadowLayer {
                $0.cornerRadius = cornerRadius
            }
        }
    }

    override public var backgroundColor: CGColor? {
        didSet {
            forEachShadowLayer {
                $0.backgroundColor = backgroundColor
            }
        }
    }

    // MARK: - Sublayer

    override open func insertSublayer(_ layer: CALayer, at idx: UInt32) {
        super.insertSublayer(layer, at: idx)

        if let shadow = layer as? ShadowLayer {
            shadow.copySuperlayerPropertiesForShadow()
        }
    }

    // MARK: - Layout

    override public func layoutSublayers() {
        super.layoutSublayers()

        forEachShadowLayer {
            $0.frame = bounds
        }
    }
}

// MARK: - CALayer + ShadowLayer

extension CALayer {

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

// MARK: - CALayer + SuperlayerShadow

extension CALayer {

    /// Copy shadow relevant properties of `superlayer` to `self`
    /// - Warning: These aren't the `ShadowComponents`
    func copySuperlayerPropertiesForShadow() {
        guard let superlayer = superlayer else { return }

        // cornerRadius
        cornerRadius = superlayer.cornerRadius

        // This is important because layers with no background colour
        // cannot render shadows
        // backgroundColor
        backgroundColor = superlayer.backgroundColor

        // frame
        frame = superlayer.bounds

        if #available(iOS 13, *) {
            // cornerCurve
            cornerCurve = superlayer.cornerCurve
        }
    }
}

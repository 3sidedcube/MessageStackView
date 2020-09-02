//
//  ShadowLayer.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// Subclass of `CALayer` for explicit type
internal class ShadowLayer: CALayer {
    
    // MARK: - Init
    
    /// Initialize `ShadowLayer`
    ///
    /// - Parameters:
    ///   - shadowComponents: `ShadowComponents`
    init (shadowComponents: ShadowComponents) {
        super.init()
        self.shadowComponents = shadowComponents
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Copy shadow relevant properties of `superlayer` to `self`
    func superlayerDidUpdate() {
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

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
    
    public override init() {
        super.init()
        setup()
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        masksToBounds = false
        backgroundColor = UIColor.clear.cgColor
    }
}

//
//  ShadowView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// A subclass of `UIView` which sets the layer to `ParentShadowLayer` which
/// manages `ShadowLayer` sublayers
open class ShadowView: UIView {
    
    // MARK: - Layer
    
    public override class var layerClass: AnyClass {
        return ParentShadowLayer.self
    }
    
    // MARK: - Init
    
    convenience public init() {
        self.init(frame: .zero)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        clipsToBounds = false
    }
}

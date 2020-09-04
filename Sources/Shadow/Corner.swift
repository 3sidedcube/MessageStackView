//
//  Corner.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// Describes the corners of an entity
public enum Corner {
    
    /// Entity is rounded by `value` but may not be `.circular`
    case rounded(_ cornerRadius: CGFloat)
    
    /// Entity is a circle
    case circular
}

// MARK: - Corner + Functionality

public extension Corner {
    
    /// `Corner` to `CALayerCornerCurve`
    @available(iOS 13, *)
    var cornerCurve: CALayerCornerCurve {
        switch self {
        case .rounded: return .continuous
        case .circular: return .circular
        }
    }
}

// MARK: - CALayer + Corner

public extension CALayer {
    
    /// Precision epsilon when calculating `Corner`
    private static let epsilon: CGFloat = 0.0001
    
    /// Calculate `Corner` from the relative values of:
    /// - Width
    /// - Height
    /// - CornerRadius
    internal var calculatedCorner: Corner {
        let width = bounds.size.width
        let height = bounds.size.height
        
        // Is the width == height
        let widthEqualsHeight = width.isFloatingPointEqual(
            to: height, withPrecision: Self.epsilon
        )
        
        // Is width * 0.5 == cornerRadius
        let halfWidthEqualsCornerRadius = (width * 0.5).isFloatingPointEqual(
            to: cornerRadius, withPrecision: Self.epsilon
        )
        
        if widthEqualsHeight, halfWidthEqualsCornerRadius {
            return .circular
        }
        
        return .rounded(cornerRadius)
    }
    
    /// Apply `corner` to the `CALayer` instance 
    /// - Parameter corner: `Corner`
    func setCorner(_ corner: Corner) {
        switch corner {
            
        // rounded
        case .rounded(let cornerRadius):
            self.cornerRadius = cornerRadius
            
        // circular
        case .circular:
            let width = bounds.size.width
            let height = bounds.size.height
            let size = min(width, height)
            
            cornerRadius = 0.5 * size
        }
        
        // cornerCurve
        if #available(iOS 13, *) {
            cornerCurve = corner.cornerCurve
        }
    }
}

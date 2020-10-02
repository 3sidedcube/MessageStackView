//
//  UIView+ShadowComponents.swift
//  MessageStackView
//
//  Created by Simon Mitchell on 10/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

/// Component representation of all properties required to render a shadow in UIKit
public struct ShadowComponents {
    
    /// The blur radius of the shadow
    public let radius: CGFloat
    
    /// The opacity of the shadow
    public let opacity: Float
    
    /// The color of the shadow
    public let color: UIColor
    
    /// The offset of the shadow
    public let offset: CGSize
    
    /// Default public memberwise initialiser
    /// - Parameters:
    ///   - radius: The blur radius of the shadow
    ///   - opacity: The opacity of the shadow
    ///   - color: The color of the shadow
    ///   - offset: The offset of the shadow
    public init(
        radius: CGFloat,
        opacity: Float,
        color: UIColor,
        offset: CGSize
    ) {
        self.radius = radius
        self.opacity = opacity
        self.color = color
        self.offset = offset
    }
    
    /// Default shadow properties on  `CALayer` from UIKit
    /// - Note: This won't show any shadow
    public static let `default` = ShadowComponents(
        radius: 3,
        opacity: 0,
        color: .black,
        offset: CGSize(width: 0, height: -3)
    )
    
    /// Default shadow gray
    public static let defaultBlack = ShadowComponents(
        radius: 3,
        opacity: 0.15,
        color: .black,
        offset: CGSize(width: 0, height: 1.5)
    )
}

// MARK: - CALayer + ShadowComponents

public extension CALayer {
    
    var shadowComponents: ShadowComponents? {
        set {
            guard let newValue = newValue else {
                setShadowComponents(.default)
                return
            }
            setShadowComponents(newValue)
        }
        get {
            guard let shadowColor = shadowColor else {
                return nil
            }
            let color = UIColor(cgColor: shadowColor)
            return ShadowComponents(
                radius: shadowRadius,
                opacity: shadowOpacity,
                color: color,
                offset: shadowOffset
            )
        }
    }
    
    /// Set properties on the `CALayer` given by `components`
    /// - Parameter components: `ShadowComponents`
    private func setShadowComponents(_ components: ShadowComponents) {
        shadowRadius = components.radius
        shadowOpacity = components.opacity
        shadowColor = components.color.cgColor
        shadowOffset = components.offset
    }
}

// MARK: - UIView + ShadowComponents

public extension UIView {
    
    var shadowComponents: ShadowComponents? {
        get {
            return layer.shadowComponents
        }
        set {
            layer.shadowComponents = newValue
        }
    }
}

//
//  UIView+ShadowComponents.swift
//  MessageStackView
//
//  Created by Simon Mitchell on 10/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import UIKit

public extension UIView {
    
    /// Component representation of all properties required to render a shadow in UIKit
    struct ShadowComponents {
        
        /// The blur radius of the shadow
        let radius: CGFloat
        
        /// The opacity of the shadow
        let opacity: Float
        
        /// The color of the shadow
        let color: UIColor
        
        /// The offset of the shadow
        let offset: CGSize
        
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
        
        static let `default` = ShadowComponents(
            radius: 3,
            opacity: 0.6,
            color: .lightGray,
            offset: .zero
        )
    }
    
    var shadow: ShadowComponents? {
        set {
            guard let newValue = newValue else {
                layer.shadowRadius = 0
                layer.shadowOpacity = 0
                layer.shadowColor = nil
                layer.shadowOffset = .zero
                return
            }
            layer.shadowRadius = newValue.radius
            layer.shadowOpacity = newValue.opacity
            layer.shadowColor = newValue.color.cgColor
            layer.shadowOffset = newValue.offset
        }
        get {
            guard let shadowColor = layer.shadowColor else {
                return nil
            }
            let color = UIColor(cgColor: shadowColor)
            return ShadowComponents(
                radius: layer.shadowRadius,
                opacity: layer.shadowOpacity,
                color: color,
                offset: layer.shadowOffset
            )
        }
    }
}

//
//  UIView+Shadow.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

// MARK: - UIView + Shadow

extension UIView {
    
    /// Add shadow below a `UIView`
    func addShadowBelow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1
    }
    
    /// Reset `UIView` shadow properties back to default
    func removeShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowRadius = 3
    }
}

// MARK: - UIView + RoundedShadow

extension UIView {
    
    /// Set the `layer` corner radius
    func updateCornerRadius(_ cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.allowsEdgeAntialiasing = true
    }
    
    /// Configure the `layer` shadow
    func updateRoundedShadowPath() {
        layer.shadowPath = roundedPath.cgPath
    }
    
    /// `UIBezierPath` to draw the shadow
    var roundedPath: UIBezierPath {
        return UIBezierPath(
            roundedRect: bounds,
            cornerRadius: layer.cornerRadius
        )
    }
}

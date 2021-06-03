//
//  UIView+Shadow.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

// MARK: - UIView + Shadow

extension UIView {

    /// Add shadow below a `UIView`
    /// - Parameter setMask: Update `layer.masksToBounds` and `clipsToBounds`
    func addShadowBelow(setMask: Bool = true) {
        if setMask {
            layer.masksToBounds = false
            clipsToBounds = false
        }

        shadowComponents = ShadowComponents(
            radius: 1,
            opacity: 0.6,
            color: .lightGray,
            offset: CGSize(width: 0, height: 1)
        )
    }

    /// Reset `UIView` shadow properties back to default
    /// - Parameter setMask: Update `layer.masksToBounds` and `clipsToBounds`
    func removeShadow(setMask: Bool = true) {
        if setMask {
            layer.masksToBounds = false
            clipsToBounds = false
        }
        shadowComponents = nil
    }
}

// MARK: - CALayer + RoundedShadow

extension CALayer {

    /// Set the `layer` corner radius
    func updateCornerRadius(_ cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        allowsEdgeAntialiasing = true
    }

    /// Configure the `layer` shadow
    func updateRoundedShadowPath() {
        shadowPath = roundedPath.cgPath
    }

    /// `UIBezierPath` to draw the shadow
    var roundedPath: UIBezierPath {
        return UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        )
    }
}

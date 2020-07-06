//
//  BadgeContainerView.swift
//  Ex
//
//  Created by Ben Shutt on 05/03/2020.
//  Copyright © 2020 BenShutt. All rights reserved.
//

import UIKit

/// The background view of a badge image.
///
/// - Note:
/// Inherit `ShakeView` to add badge animations
class BadgeContainerView: UIView {
    
    /// Fixed constants
    private struct Constants {
        
        /// `UIColor` of the shadow
        static let shadowColor: UIColor = .lightGray

        /// `CGFloat` to determine the opacity/alpha of the shadow
        static let shadowOpacity: Float = 0.6

        /// `CGFloat` radius of the shadow
        static let shadowRadius: CGFloat = 3

        /// Instrinsic width and height of `BadgeContainerView`
        static let intrinsicSize: CGFloat = 150
    }
    
    /// Amount the fill path is inset by from the `bounds`
    var containerBorderWidth: CGFloat = 2 { didSet { setNeedsDisplay() } }
    
    /// The corner radius of the rounded rect path
    var containerCornerRadius: CGFloat = 35 { didSet { setNeedsLayout() } }
    
    /// The color of the border
    var containerBorderColor: UIColor = .white { didSet { setNeedsDisplay() } }
    
    /// The color to fill the view, rounded rect inset by `borderWidth` from `bounds`
    var fillColor: UIColor = .arcRed { didSet { setNeedsDisplay() } }
    
    // MARK: - Init
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        updateLayer()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayer()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: Constants.intrinsicSize,
            height: Constants.intrinsicSize
        )
    }
    
    // MARK: - Draw
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Fill the whole bounds with the border color
        fillRoundedPath(
            rect: bounds,
            fillColor: containerBorderColor
        )
        
        // On top of the whole bounds border color, fill the color
        fillRoundedPath(
            rect: bounds.inset(by: containerBorderWidth),
            fillColor: fillColor
        )
    }
    
    // MARK: - Path
    
    /// Round `rect` with `cornerRadius`
    /// - Parameter rect: `CGRect` to round
    private func roundedPath(for rect: CGRect) -> UIBezierPath {
        return UIBezierPath(
            roundedRect: rect,
            cornerRadius: containerCornerRadius
        )
    }
    
    /// Get `roundedRect(for:)` and fill with `fillColor`
    /// - Parameters:
    ///   - rect: `CGRect` to round
    ///   - fillColor: `UIColor` to fill
    private func fillRoundedPath(rect: CGRect, fillColor: UIColor) {
        let path = roundedPath(for: rect)
        fillColor.setFill()
        path.fill()
    }
    
    // MARK: - Layer
    
    /// Update:
    /// - corner radius
    /// - shadow
    private func updateLayer() {
        updateCorners()
        updateShadow()
    }
    
    /// Set the `layer` corner radius
    private func updateCorners() {
        layer.cornerRadius = containerCornerRadius
        layer.allowsEdgeAntialiasing = true
    }
    
    /// Configure the `layer` shadow
    private func updateShadow() {
        layer.shadowColor = Constants.shadowColor.cgColor
        layer.shadowOffset = .zero
        layer.shadowPath = roundedPath(for: bounds).cgPath
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
    }
}

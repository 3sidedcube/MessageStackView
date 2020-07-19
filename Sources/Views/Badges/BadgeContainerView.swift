//
//  BadgeContainerView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 05/03/2020.
//  Copyright © 2020 BenShutt. All rights reserved.
//

import UIKit

/// The background view of a badge image.
///
/// - Note:
/// Inherit `ShakeView` to add badge animations
open class BadgeContainerView: UIView {
    
    /// Overrideable default shadow components for `BadgeContainerView`
    public static var shadowComponents: UIView.ShadowComponents = .default
    
    /// Fixed constants
    private struct Constants {
        
        /// Instrinsic width and height of `BadgeContainerView`
        static let intrinsicSize: CGFloat = 150
    }
    
    /// Amount the fill path is inset by from the `bounds`
    public var containerBorderWidthScale: CGFloat = 1/75 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The corner radius of the rounded rect path
    public var containerCornerRadiusScale: CGFloat = 7/30 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The color of the border
    public var containerBorderColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The color to fill the view, rounded rect inset by `borderWidth` from `bounds`
    public var fillColor: UIColor = .themeRed {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Computed
    
    /// Min of the `bounds` width and height
    private var size: CGFloat {
        return min(bounds.size.width, bounds.size.height)
    }
    
    /// Corner radius by scaling `size` according to `containerCornerRadiusScale`
    private var cornerRadius: CGFloat {
        return containerCornerRadiusScale * size
    }
    
    /// Border width by scaling `size` according to `containerBorderWidthScale`
    private var borderWidth: CGFloat {
        return containerBorderWidthScale * size
    }
    
    // MARK: - Init
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        shadow = BadgeContainerView.shadowComponents
        updateLayer()
    }
    
    // MARK: - Lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayer()
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(
            width: Constants.intrinsicSize,
            height: Constants.intrinsicSize
        )
    }
    
    // MARK: - Draw
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Fill the whole bounds with the border color
        fillRoundedPath(
            rect: bounds,
            fillColor: containerBorderColor
        )
        
        // On top of the whole bounds border color, fill the color
        fillRoundedPath(
            rect: bounds.inset(by: borderWidth),
            fillColor: fillColor
        )
    }
    
    // MARK: - Path
    
    /// Round `rect` with `cornerRadius`
    /// - Parameter rect: `CGRect` to round
    private func roundedPath(for rect: CGRect) -> UIBezierPath {
        return UIBezierPath(
            roundedRect: rect,
            cornerRadius: cornerRadius
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
    
    /// Update `layer`:
    /// - cornerRadius
    /// - shadow
    private func updateLayer() {
        updateCornerRadius(cornerRadius)
        updateRoundedShadowPath()
    }
}

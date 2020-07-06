//
//  BadgeMessageView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

/// A `UIView` often toasted from the top of a screen to detail a message.
/// This is a more comprehensive `MessageView`
open class BadgeMessageView: UIView {
    
    /// Fixed constants for `BadgeMessageView`
    private struct Constants {
        
        /// Corner radius of the `BadgeMessageView`
        static let cornerRadius: CGFloat = 16
        
        /// `UIImage` for the cancel `UIButton`
        static let cancelImage: UIImage? = .iconClose
        
        /// `CGFloat` inset value for the `UIButton`
        static let buttonInset = UIEdgeInsets(value: 10)
        
        /// `UIEdgeInsets` of the `horizontalStackView` from self
        static let horizontalStackViewInsets = UIEdgeInsets(
            top: 20, left: 15, bottom: 20, right: 15
        )
        
        /// Fixed `CGSize` of the `badgeView`
        static let badgeViewSize = CGSize(width: 48, height: 48)
        
        /// `CALayer` `opacity` for `backgroundImageView`
        static let backgroundImageViewOpacity: Float = 0.06
    }
    
    // MARK: - Subviews
    
    /// Root, horizontally aligned `UIStackView`
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    /// `UIImageView` behind the `badgeView` for a background effect
    private(set) lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.layer.opacity = Constants.backgroundImageViewOpacity
        return imageView
    }()
    
    /// `BadgeView` at the leading edge of the `horizontalStackView`
    private lazy var badgeView = BadgeView()
    
    /// Vertically aligned `UIStackView` for the `titleLabel` and `subtitleLabel`.
    /// Central between `badgeView` and `button`.
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    /// `UILabel` at the top of `verticalStackView`
    public private(set) lazy var titleLabel: UILabel = {
        let label = UILabel.default
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        return label
    }()
    
    /// `UILabel` at the bottom of `verticalStackView`
    public private(set) lazy var subtitleLabel: UILabel = {
        return UILabel.default
    }()
    
    /// `UIButton` at the trailing edge of the `stackView`
    public private(set) lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(Constants.cancelImage, for: .normal)
        button.setTitle(nil, for: .normal)
        button.contentEdgeInsets = Constants.buttonInset
        return button
    }()
    
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
        // backgroundColor
        backgroundColor = .white
        
        // cornerRadius
        layer.cornerRadius = Constants.cornerRadius
        
        // layer
        updateLayer()
        
        // Add subviews to `self` and add constraints
        addSubviewsAndConstrain()
    }
    
    // MARK: - Constraints
    
    private func addSubviewsAndConstrain() {
        // verticalStackView
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleLabel)
        
        // horizontalStackView
        horizontalStackView.addArrangedSubview(badgeView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(button)
        
        // self
        addSubview(backgroundImageView)
        addSubview(horizontalStackView)
        
        addConstraints()
    }
    
    private func addConstraints() {
        // horizontalStackView
        var edgeConstraints = horizontalStackView.edgeConstraints(to: self)
        edgeConstraints.insets = Constants.horizontalStackViewInsets
        
        // badgeView
        let size = badgeView.sizeConstraints(size: Constants.badgeViewSize)
        
        // backgroundImageView
        backgroundImageView.sizeConstraints(size: CGSize(
            width: 2 * size.width.constant,
            height: 2 * size.height.constant
        ))
        
        NSLayoutConstraint.activate([
            // backgroundImageView
            backgroundImageView.centerXAnchor.constraint(
                equalTo: badgeView.centerXAnchor
            ),
            backgroundImageView.centerYAnchor.constraint(
                equalTo: badgeView.centerYAnchor
            )
        ])
    }
    
    // MARK: - LAyout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayer()
    }
    
    /// Update cornerRadius and shadow
    private func updateLayer() {
        updateCornerRadius(Constants.cornerRadius)
        updateRoundedShadow()
    }
}

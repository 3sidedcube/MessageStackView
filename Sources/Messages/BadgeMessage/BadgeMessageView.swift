//
//  BadgeMessageView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// A `UIView` often toasted from the top of a screen to detail a message.
/// This is a more comprehensive `MessageView`.
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
            top: 20, left: 15, bottom: 20, right: 15 - buttonInset.right
        )
        
        /// Fixed `CGSize` of the `badgeView`
        static let badgeViewSize = CGSize(width: 48, height: 48)
        
        /// `CALayer` `opacity` for `backgroundImageView`
        static let backgroundImageViewOpacity: Float = 0.06
        
        /// Translate the `backgroundImageView` in X by this amount
        static let backgroundImageViewTranslationX: CGFloat = -8
    }
    
    /// Overrideable default shadow components for `BadgeMessageView`
    public static var shadowComponents: ShadowComponents = .defaultBlack
    
    // MARK: - Subviews
    
    /// Subview of `self` but container (super) `UIView` for all other subviews.
    /// This is so this `UIView` can clip content but we can apply shadow on `self`.
    private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        return view
    }()
    
    /// Root, horizontally aligned `UIStackView`
    public private(set) lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 22
        return stackView
    }()
    
    /// `UIImageView` behind the `badgeView` for a background effect
    public private(set) lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.layer.opacity = Constants.backgroundImageViewOpacity
        imageView.transform = CGAffineTransform(
            translationX: Constants.backgroundImageViewTranslationX,
            y: 0
        )
        return imageView
    }()
    
    /// `BadgeView` at the leading edge of the `horizontalStackView`
    public private(set) lazy var badgeView = BadgeView()
    
    /// Vertically aligned `UIStackView` for the `titleLabel` and `subtitleLabel`.
    /// Central between `badgeView` and `button`.
    public private(set) lazy var verticalStackView: UIStackView = {
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
        label.textColor = .black
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
    
    // MARK: - containerViewInsets
    
    /// `UIEdgeInsets` of `containerViewEdgeConstraints`
    public var containerViewInsets: UIEdgeInsets {
        get {
            return containerViewEdgeConstraints.insets
        }
        set {
            containerViewEdgeConstraints.insets = newValue
        }
    }
    
    /// `EdgeConstraints` constraining `containerView` to `self`
    private var containerViewEdgeConstraints: EdgeConstraints!
    
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
        containerView.layer.cornerRadius = layer.cornerRadius
        shadowComponents = BadgeMessageView.shadowComponents
        
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
            containerView.layer.cornerCurve = .continuous
        }
        
        // layer
        updateLayer()
        
        // Add subviews to `self` and add constraints
        addSubviewsAndConstrain()
        
        // Add target for dismiss on `.touchUpInside`
        button.addTarget(
            self,
            action: #selector(buttonTouchUpInside),
            for: .touchUpInside
        )
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
        
        // containerView
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(horizontalStackView)
        
        // self
        addSubview(containerView)
        
        // Constrain
        addConstraints()
    }
    
    private func addConstraints() {
        // containerView
        containerViewEdgeConstraints = containerView.edgeConstraints(to: self)
        
        // horizontalStackView
        horizontalStackView.edgeConstraints(
            to: containerView,
            insets: Constants.horizontalStackViewInsets
        )
        
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
        
        // button
        let axes: [NSLayoutConstraint.Axis] = [.vertical, .horizontal]
        axes.forEach {
            let priority = UILayoutPriority(800)
            button.setContentHuggingPriority(priority, for: $0)
            button.setContentCompressionResistancePriority(priority, for: $0)
        }
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayer()
    }
    
    /// Update cornerRadius and shadow
    private func updateLayer() {
        updateCornerRadius(Constants.cornerRadius)
        updateRoundedShadowPath()
    }
    
    // MARK: - UIControlEvent
    
    /// On `sender` `.touchUpInside`, find the first `Poster` superview and call
    /// remove
    /// - Parameter sender: `UIButton`
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        let poster: Poster? = sender.firstSuperviewOfType()
        let request = poster?.postManager.currentPostRequests
            .first { $0.view == self }
        
        if let postRequest = request {
            poster?.postManager.remove(postRequest: postRequest)
        }
    }
}

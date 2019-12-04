//
//  MessageView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

/// A `UIView` for showing messages. It has a subview tree structure of:
/// - ContainerView
///   - Horizontally oriented `UIStackView`:
///     - `UIImageView`
///     - Vertically oriented `UIStackView`
///       - Title `UILabel`
///       - Detail `UILabel`
open class MessageView : UIView
{
    /// Constants for the `MessageView`
    public struct Constants
    {
        /// Size of the `UIImageView`
        static let imageViewSize: CGSize = CGSize(width: 20, height: 20)
        
        /// Inset of the `UIStackView` relative to the `MessageView`
        static let stackViewInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        /// Vertical `UIStackView` spacing
        static let verticalStackViewSpacing: CGFloat = 5
        
        /// Horizontal `UIStackView` spacing
        static let horizontalStackViewSpacing: CGFloat = 10
        
        /// Default tint color for view
        static let defaultTintColor = UIColor.darkGray
        
        /// Default font for `titleLabel`
        static let titleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        /// Default font for `detailLabel`
        static let detailFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    /// Container view for other subviews of `MessageView`.
    /// Required for shadow: for smooth animations we need to clip subview content (`clipsToBounds = true` ),
    /// but this would remove shadow. So clip this `containerView`, but allow out of bounds content on the `MessageView`
    public private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        /// Hide subview content when the height of this view is being animated
        view.clipsToBounds = true
        
        return view
    }()
    
    /// `UIStackView` subview of `MessageView` to position `UIImageView` and `UILabel`
    public private(set) lazy var horizontalStackView: UIStackView = {
        let stackView = MessageView.defaultStackView(axis: .horizontal)
        stackView.alignment = .center
        stackView.spacing = Constants.horizontalStackViewSpacing
        return stackView
    }()
    
    /// `UIImageView`, first arrangedSubview of the horizontally oriented `UIStackView`
    public private(set) lazy var leftImageView: UIImageView = {
        return MessageView.defaultImageView()
    }()
    
    /// `UIStackView` subview of `MessageView` to position `UIImageView` and `UILabel`
    public private(set) lazy var verticalStackView: UIStackView = {
        let stackView = MessageView.defaultStackView(axis: .vertical)
        stackView.spacing = Constants.verticalStackViewSpacing
        return stackView
    }()
    
    /// `UILabel`, last arrangedSubview of the horizontally oriented `UIStackView`
    public private(set) lazy var titleLabel: UILabel = {
        let label = MessageView.defaultLabel()
        label.font = Constants.titleFont
        return label
    }()
    
    /// `UILabel`, last arrangedSubview of the horizontally oriented `UIStackView`
    public private(set) lazy var subtitleLabel: UILabel = {
        let label = MessageView.defaultLabel()
        label.font = Constants.detailFont
        return label
    }()
    
    /// `UIImageView`, first arrangedSubview of the horizontally oriented `UIStackView`
    public private(set) lazy var rightImageView: UIImageView = {
        return MessageView.defaultImageView()
    }()
    
    /// `CGSize` of the `leftImageView`
    public var leftImageViewSize: CGSize = Constants.imageViewSize {
        didSet {
            leftImageSizeConstaints?.setWidth(constant: leftImageViewSize.width)
            leftImageSizeConstaints?.setHeight(constant: leftImageViewSize.height)
        }
    }
    
    /// `CGSize` of the `rightImageView`
    public var rightImageViewSize: CGSize = Constants.imageViewSize {
        didSet {
            rightImageSizeConstaints?.setWidth(constant: rightImageViewSize.width)
            rightImageSizeConstaints?.setHeight(constant: rightImageViewSize.height)
        }
    }
    
    /// `NSLayoutConstraints` setting the `SizeConstraints` on the `leftImageView`
    private var leftImageSizeConstaints: SizeConstraints!
    
    /// `NSLayoutConstraints` setting the `SizeConstraints` on the `rightImageView`
    private var rightImageSizeConstaints: SizeConstraints!
    
    // MARK: - Init
    
    /// Create with default frame
    public convenience init() {
        self.init(frame: .zero)
    }
    
    /// Create with explicit frame - `CGRect`
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /// Create with coder - `NSCoder`
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    /// Add subviews and constrain
    internal func setup()
    {
        /// Explicity set default tintColor
        tintColor = Constants.defaultTintColor
        
        // Add subviews
        addSubview(containerView)
        containerView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(leftImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(rightImageView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleLabel)
        
        // Set translatesAutoresizingMaskIntoConstraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set hugging and compressionResistance
        subtitleLabel.setContentHuggingPriority(.init(200), for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.init(700), for: .vertical)
        
        // Constrain
        var constraints = constrainToEdges(for: containerView)

        // When the view is being hidden in an animation, allow the bottom constraint to break so the animation is smooth
        let horizontalStackViewBottom = horizontalStackView.bottomAnchor.constraint(
            equalTo: containerView.bottomAnchor, constant: -Constants.stackViewInsets.bottom)
        horizontalStackViewBottom.priority = .init(999)
        
        constraints += [
            horizontalStackView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor, constant: Constants.stackViewInsets.left),
            horizontalStackView.topAnchor.constraint(
                equalTo: containerView.topAnchor, constant: Constants.stackViewInsets.top),
            horizontalStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor, constant: -Constants.stackViewInsets.right),
            horizontalStackViewBottom
        ]
        leftImageSizeConstaints = leftImageView.constrainSize(size: Constants.imageViewSize)
        constraints += leftImageSizeConstaints?.constraints ?? []
        
        rightImageSizeConstaints = rightImageView.constrainSize(size: Constants.imageViewSize)
        constraints += rightImageSizeConstaints?.constraints ?? []
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Override
    
    public override var tintColor: UIColor! {
        didSet {
            leftImageView.tintColor = tintColor
            titleLabel.textColor = tintColor
            subtitleLabel.textColor = tintColor
            rightImageView.tintColor = tintColor
        }
    }
    
    // MARK: - Defaults
    
    private static func defaultImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = nil
        return imageView
    }
    
    private static func defaultLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }
    
    private static func defaultStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }
}

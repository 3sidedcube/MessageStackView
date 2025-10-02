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
open class MessageView: UIView {

    /// Constants for the `MessageView`
    public struct Constants {

        /// Size of the `UIImageView`
        static let imageViewSize = CGSize(width: 20, height: 20)

        /// Inset of the `UIStackView` relative to the `MessageView`
        static let stackViewInsets = UIEdgeInsets(
            top: 10, left: 16, bottom: 10, right: 16
        )

        /// Vertical `UIStackView` spacing
        static let verticalStackViewSpacing: CGFloat = 12

        /// Horizontal `UIStackView` spacing
        static let horizontalStackViewSpacing: CGFloat = 10

        /// Label `UIStackView` spacing
        static let labelStackViewSpacing: CGFloat = 5

        /// Button `UIStackView` spacing
        static let buttonStackViewSpacing: CGFloat = 12

        /// Default tint color for view
        static let defaultTintColor = UIColor.darkGray

        /// Default font for `titleLabel`
        static let titleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)

        /// Default font for `detailLabel`
        static let detailFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    }

    /// Container view for other subviews of `MessageView`.
    /// Required for shadow: for smooth animations we need to clip subview content (`clipsToBounds = true` ),
    /// but this would remove shadow.
    /// So clip this `containerView`, but allow out of bounds content on the `MessageView`
    public private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        // Hide subview content when the height of this view is being animated
        view.clipsToBounds = true
        return view
    }()

    /// `UIStackView` subview of `MessageView` to `horizontalStackView` and `buttonStackView`.
    public private(set) lazy var verticalStackView: UIStackView = {
        let stackView: UIStackView = .defaultStackView
        stackView.spacing = Constants.verticalStackViewSpacing
        return stackView
    }()

    /// `UIStackView` subview of `MessageView` to position `UIImageView`s and `UILabel`s
    public private(set) lazy var horizontalStackView: UIStackView = {
        let stackView: UIStackView = .defaultStackView
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Constants.horizontalStackViewSpacing
        return stackView
    }()

    /// `UIImageView`, first arrangedSubview of the horizontally oriented `UIStackView`
    public private(set) lazy var leftImageView: UIImageView = {
        return .defaultImageView
    }()

    /// `UIStackView` subview of `MessageView` to position `UILabel`s
    public private(set) lazy var labelStackView: UIStackView = {
        let stackView: UIStackView = .defaultStackView
        stackView.spacing = Constants.labelStackViewSpacing
        return stackView
    }()

    /// `UILabel`, last arrangedSubview of the horizontally oriented `UIStackView`
    public private(set) lazy var titleLabel: UILabel = {
        let label: UILabel = .default
        label.font = Constants.titleFont
        label.textColor = .black
        return label
    }()

    /// `UILabel`, last arrangedSubview of the horizontally oriented `UIStackView`
    public private(set) lazy var subtitleLabel: UILabel = {
        let label: UILabel = .default
        label.font = Constants.detailFont
        label.textColor = .darkGray
        return label
    }()

    /// `UIImageView`, first arrangedSubview of the horizontally oriented `UIStackView`
    public private(set) lazy var rightImageView: UIImageView = {
        return .defaultImageView
    }()

    /// `UIStackView` subview of `MessageView` to position `UIButtons`s
    public private(set) lazy var buttonStackView: UIStackView = {
        let stackView: UIStackView = .defaultStackView
        stackView.axis = .horizontal
        stackView.spacing = Constants.buttonStackViewSpacing
        stackView.distribution = .fillEqually
        return stackView
    }()

    /// Filled `UIButton` on the left
    public private(set) lazy var primaryButton: UIButton = {
        let button: UIButton = .defaultButton
        button.setTitle("PRIMARY", for: .normal)
        button.backgroundColor = .white
        return button
    }()

    /// Bordered `UIButton` on the right
    public private(set) lazy var secondaryButton: UIButton = {
        let button: UIButton = .defaultButton
        button.setTitle("SECONDARY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    /// `CGSize` of the `leftImageView`
    public var leftImageViewSize: CGSize = Constants.imageViewSize {
        didSet {
            leftImageSizeConstraints.setSize(leftImageViewSize)
        }
    }

    /// `CGSize` of the `rightImageView`
    public var rightImageViewSize: CGSize = Constants.imageViewSize {
        didSet {
            rightImageSizeConstraints.setSize(rightImageViewSize)
        }
    }

    /// `EdgeConstraints` of `horizontalStackView` to `self`
    private var edgeConstraints: EdgeConstraints!

    /// `NSLayoutConstraints` setting the `SizeConstraints` on the `leftImageView`
    private var leftImageSizeConstraints: SizeConstraints!

    /// `NSLayoutConstraints` setting the `SizeConstraints` on the `rightImageView`
    private var rightImageSizeConstraints: SizeConstraints!

    /// Get and set `insets` of `UIEdgeInsets`
    public var insets: UIEdgeInsets {
        get {
            return edgeConstraints.insets
        }
        set {
            edgeConstraints.insets = newValue
        }
    }

    // MARK: - Init

    /// Create with default frame
    public convenience init() {
        self.init(frame: .zero)
    }

    /// Create with explicit frame - `CGRect`
    override public init(frame: CGRect) {
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
    internal func setup() {

        /// Explicitly set default tintColor
        tintColor = Constants.defaultTintColor

        // Add subviews
        addSubview(containerView)
        containerView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(buttonStackView)
        horizontalStackView.addArrangedSubview(leftImageView)
        horizontalStackView.addArrangedSubview(labelStackView)
        horizontalStackView.addArrangedSubview(rightImageView)
        buttonStackView.addArrangedSubview(primaryButton)
        buttonStackView.addArrangedSubview(secondaryButton)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)

        // Set translatesAutoresizingMaskIntoConstraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false

        // Set hugging and compressionResistance
        subtitleLabel.setContentHuggingPriority(.init(200), for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.init(700), for: .vertical)

        // Constrain
        var constraints = containerView.edgeConstraints(to: self).constraints

        // EdgeConstraints
        edgeConstraints = verticalStackView.edgeConstraints(
            to: containerView, insets: Constants.stackViewInsets
        )
        constraints += edgeConstraints.constraints

        // When the view is being hidden in an animation, allow the bottom constraint to break so the animation is smooth
        edgeConstraints.bottom.priority = .init(999)

        // Left image constraints
        leftImageSizeConstraints = leftImageView.sizeConstraints(size: Constants.imageViewSize)
        constraints += leftImageSizeConstraints?.constraints ?? []

        // Right image constraints
        rightImageSizeConstraints = rightImageView.sizeConstraints(size: Constants.imageViewSize)
        constraints += rightImageSizeConstraints?.constraints ?? []

        // Button constraints
        constraints.append(buttonStackView.heightAnchor.constraint(equalToConstant: 40))

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Override

    override public var tintColor: UIColor! {
        didSet {
            leftImageView.tintColor = tintColor
            titleLabel.textColor = tintColor
            subtitleLabel.textColor = tintColor
            rightImageView.tintColor = tintColor
        }
    }

    override public var backgroundColor: UIColor! {
        didSet {
            primaryButton.setTitleColor(backgroundColor, for: .normal)
        }
    }
}

// MARK: - UIStackView + Default

private extension UIStackView {

    /// `UIStackView` setting default properties
    static var defaultStackView: UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }
}

// MARK: - UIImageView + Default

private extension UIImageView {

    /// `UIImageView` setting default properties
    static var defaultImageView: UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = nil
        return imageView
    }
}

// MARK: - UIButton + Default

private extension UIButton {
    
    /// `UIButton` setting default properties
    static var defaultButton: UIButton {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .heavy)
        button.layer.updateCornerRadius(6)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }
}

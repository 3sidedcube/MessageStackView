//
//  BadgeView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 05/03/2020.
//  Copyright © 2020 BenShutt. All rights reserved.
//

import UIKit

/// `UIView` for displaying a badge.
open class BadgeView: BadgeContainerView {

    /// `UIImageView` subview
    public private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    /// The constraint between the image view's width and the
    /// container view's width. Can be adjusted to change how much
    /// of the container the image fills
    private var imageWidthConstraint: NSLayoutConstraint!

    // MARK: - Computed

    /// Width of `imageView` subview relative to `self`
    public var imageSizeRatio: CGFloat = 0.65 {
        didSet {
            updateImageWidthConstraint()
            setNeedsUpdateConstraints()
        }
    }

    /// Allows setting the rendering mode of the image view,
    /// defaults to `.alwaysTemplate`
    public var renderingMode: UIImage.RenderingMode = .alwaysTemplate {
        didSet {
            imageView.image = image?.withRenderingMode(renderingMode)
        }
    }

    /// Shorthand for getting and setting `image` of `imageView`
    public var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue?.withRenderingMode(renderingMode)
        }
    }

    /// Drive `UIImageView`s `tintColor` from `tintColor` of `self`
    override public var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
            imageView.tintColor = newValue
        }
    }

    // MARK: - Init

    public convenience init() {
        self.init(frame: .zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        updateImageWidthConstraint()
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }

    private func updateImageWidthConstraint() {
        if let widthConstraint = imageWidthConstraint {
            imageView.removeConstraint(widthConstraint)
        }
        imageWidthConstraint = imageView.widthAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: imageSizeRatio
        )
        imageWidthConstraint?.isActive = true
    }
}

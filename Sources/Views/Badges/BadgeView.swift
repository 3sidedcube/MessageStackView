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
    
    /// Fixed constants for `BadgeView`
    private struct Constants {
        
        /// Width of `imageView` subview relative to `self`
        static let imageViewWidthScale: CGFloat = 0.65
    }
    
    /// `UIImageView` subview
    public private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Computed

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
    public override var tintColor: UIColor! {
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
    
    public override init(frame: CGRect) {
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
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(
                equalTo: widthAnchor, multiplier:
                Constants.imageViewWidthScale
            ),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}

//
//  BadgeMessage.swift
//  MessageStackView
//
//  Created by Ben Shutt on 07/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// Model structure for the view `BadgeMessageView`
public struct BadgeMessage {

    /// `String` text for the `titleLabel`
    public var title: String?

    /// `String` subtitle for the `subtitleLabel`
    public var subtitle: String?

    /// - `UIImage` for the `badgeView` image
    /// - `UIImage` for the `backgroundImageView`
    public var image: UIImage?

    /// - Fill `UIColor` for the `badgeView`
    /// - `tintColor` for the `backgroundImageView`
    public var fillColor: UIColor

    /// Default public memberwise initializer
    /// - Parameters:
    ///   - title: `String?`
    ///   - subtitle: `String?`
    ///   - image: `UIImage?`
    ///   - fillColor: `UIColor`
    public init(
        title: String?,
        subtitle: String?,
        image: UIImage?,
        fillColor: UIColor
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.fillColor = fillColor
    }
}

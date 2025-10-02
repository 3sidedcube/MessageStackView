//
//  Message.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

/// Message model to post
public struct Message {

    /// Title of the message
    public var title: String?

    /// Subtitle of the message
    public var subtitle: String?

    /// Left `UIImage` of the message
    public var leftImage: UIImage?

    /// Right `UIImage` of the message
    public var rightImage: UIImage?

    /// Title `String` of the primary button
    public var primaryButtonTitle: String?

    /// `UIAction` of the primary button
    public var primaryButtonAction: UIAction?

    /// Title `String` of the secondary button
    public var secondaryButtonTitle: String?

    /// `UIAction` of the secondary button
    public var secondaryButtonAction: UIAction?

    /// Default public memberwise initializer.
    /// - Parameters:
    ///   - title: `String` title of the message
    ///   - subtitle: `String` subtitle of the message
    ///   - leftImage: `UIImage` on left
    ///   - rightImage: `UIImage` on right
    ///   - primaryButtonTitle: Title `String` of the primary button
    ///   - primaryButtonAction: `UIAction` of the primary button
    ///   - secondaryButtonTitle: Title `String` of  the secondary button
    ///   - secondaryButtonAction: `UIAction` of the secondary button
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        leftImage: UIImage? = nil,
        rightImage: UIImage? = nil,
        primaryButtonTitle: String? = nil,
        primaryButtonAction: UIAction? = nil,
        secondaryButtonTitle: String? = nil,
        secondaryButtonAction: UIAction? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryButtonAction = secondaryButtonAction
    }
}

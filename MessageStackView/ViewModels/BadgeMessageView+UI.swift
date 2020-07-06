//
//  BadgeMessageView+UI.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

public extension BadgeMessageView {
    
    /// `UIImage` of the `badgeView` and `backgroundImageView`
    var badgeAndBackgroundImage: UIImage? {
        get {
            return badgeView.image
        }
        set {
            let image = newValue?.withRenderingMode(.alwaysTemplate)
            badgeView.image = image
            backgroundImageView.image = image
        }
    }
    
    func set(
        title: String?,
        subtitle: String?,
        image: UIImage?,
        fillColor: UIColor
    ){
        // titleLabel
        titleLabel.text = title
        
        // subtitleLabel
        subtitleLabel.text = subtitle
        
        // badgeView
        badgeView.fillColor = fillColor
        
        // backgroundImageView
        backgroundImageView.tintColor = fillColor
        
        // badgeView + backgroundImageView
        badgeAndBackgroundImage = image        
    }
    
}

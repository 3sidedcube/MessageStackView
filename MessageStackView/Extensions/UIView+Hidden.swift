//
//  UIView+Hidden.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIImageView + Image + Hidden

extension UIImageView {
    
    /// Set the `UIImageView.image` and update `isHidden` by nullability of`image`
    /// - Parameter image: `UIImage` to set
    func setImageAndHidden(_ image: UIImage?) {
        self.image = image
        isHidden = image == nil
    }
}

// MARK: - UILabel + Text + Hidden

extension UILabel {
    
    /// Set the `UILabel.text` and update `isHidden` by nullability of `text`
    /// - Parameters:
    ///   - text: `String` text to set
    ///   - trim: `Bool`, trim `.whitespaceAndNewlines` from `text`
    func setTextAndHidden(_ text: String?, trim: Bool = false) {
        var labelText = text ?? ""
        if trim {
            labelText = labelText.trimmed
        }
        self.text = text
        isHidden = labelText.isEmpty
    }
}

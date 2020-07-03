//
//  UIView+Hidden.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// Set the `UIImageView.image` and update `isHidden` by nullability of`image`
    /// - Parameter image: `UIImage` to set
    func setImageAndHidden(_ image: UIImage?) {
        self.image = image
        isHidden = image == nil
    }
}

extension UILabel {
    
    /// Set the `UILabel.text` and update `isHidden` by nullability of `text`
    /// - Parameter text: `String` text to set
    func setTextAndHidden(_ text: String?) {
        let labelText = text ?? ""
        self.text = text
        isHidden = labelText.isEmpty
    }
}

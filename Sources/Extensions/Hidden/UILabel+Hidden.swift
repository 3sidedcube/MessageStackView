//
//  UILabel+Hidden.swift
//  MessageStackView
//
//  Created by Ben Shutt on 04/01/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

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

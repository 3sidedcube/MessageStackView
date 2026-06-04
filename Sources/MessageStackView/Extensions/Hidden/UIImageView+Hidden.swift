//
//  UIImageView+Hidden.swift
//  MessageStackView
//
//  Created by Ben Shutt on 04/01/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
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

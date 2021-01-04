//
//  UILabel+Default.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UILabel + Default

extension UILabel {

    /// `UILabel` setting default properties
    static var `default`: UILabel {
        let label = UILabel()
        label.textColor = .themeDarkGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = nil
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }
}

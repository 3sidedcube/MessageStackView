//
//  UIImage+Images.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// Custom `UIImage`s used in the framework - to be provided by the main app as they come
/// from the main bundle.
public extension UIImage {

    /// Gray circle with a cross in the center
    static let iconClose = UIImage("msv-iconClose")

    /// Icon for not connected to internet
    static let noInternet = UIImage("msv-noInternet")
}

// MARK: - UIImage + Init

private extension UIImage {

    /// Find a `UIImage` with name from this frameworks `Bundle`
    /// - Parameter name: Name of the `UIImage`
    convenience init?(_ name: String) {
        self.init(
            named: name,
            in: Bundle.main,
            compatibleWith: nil
        )
    }
}

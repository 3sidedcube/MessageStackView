//
//  UIImage+Images.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// Custom `UIImage`s used in the framework
public extension UIImage {

    /// Gray circle with a cross in the center
    static let iconClose = UIImage("iconClose")

    /// Icon for not connected to internet
    static let noInternet = UIImage("noInternet")
}

// MARK: - UIImage + Init

private extension UIImage {

    /// Find a `UIImage` with name from this frameworks `Bundle`
    /// - Parameter name: Name of the `UIImage`
    convenience init?(_ name: String) {
        // canImport(MessageStackViewObjC) is only true in SPM builds, where
        // resources live in Bundle.module. The framework/CocoaPods builds
        // define SWIFT_PACKAGE too, so that flag can't be used here.
        #if canImport(MessageStackViewObjC)
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: MessageStackView.self)
        #endif
        self.init(
            named: name,
            in: bundle,
            compatibleWith: nil
        )
    }
}

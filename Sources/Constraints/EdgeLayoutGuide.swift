//
//  LayoutGuide.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/06/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// Edge layout guide
protocol EdgeLayoutGuide {

    /// Leading anchor in X
    var leadingAnchor: NSLayoutXAxisAnchor { get }

    /// Top anchor in Y
    var topAnchor: NSLayoutYAxisAnchor { get }

    /// Trailing anchor in X
    var trailingAnchor: NSLayoutXAxisAnchor { get }

    /// Bottom anchor in Y
    var bottomAnchor: NSLayoutYAxisAnchor { get }
}

// MARK: - UIView + EdgeLayoutGuide

extension UIView: EdgeLayoutGuide {}

// MARK: - UILayoutGuide + EdgeLayoutGuide

extension UILayoutGuide: EdgeLayoutGuide {}

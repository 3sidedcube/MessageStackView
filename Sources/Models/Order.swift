//
//  Order.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/06/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// How posted `UIView`s are ordered.
/// E.g. the order of the `arrangedSubviews`.
public enum Order {

    /// Natural order of `UIStackView`s. Posted `UIView`s get appended to the
    /// `arrangedSubviews` array appearing below/after the previous.
    case topToBottom

    /// Reverse order of `UIStackView`s. Posted `UIView`s get inserted at the start of the
    /// `arrangedSubviews` array appearing above/before the previous.
    case bottomToTop
}

// MARK: - Extensions

public extension Order {

    /// Other `Order` (opposite direction)
    var switched: Self {
        switch self {
        case .topToBottom: return .bottomToTop
        case .bottomToTop: return .topToBottom
        }
    }
}

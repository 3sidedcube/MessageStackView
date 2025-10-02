//
//  UIView+SafeArea.swift
//  MessageStackView
//
//  Created by Ben Shutt on 25/11/2019.
//  Copyright © 2019 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

// MARK: - UIView + SafeAnchor

/// SafeArea support for pre iOS 11
extension UIView {

    /// If the safe area is available, then the `safeAreaLayoutGuide.topAnchor`,
    /// otherwise the `topAnchor`
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }

    /// If the safe area is available, then the `safeAreaLayoutGuide.leadingAnchor`,
    /// otherwise the `leadingAnchor`
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leadingAnchor
        } else {
            return self.leadingAnchor
        }
    }

    /// If the safe area is available, then the `safeAreaLayoutGuide.trailingAnchor`,
    /// otherwise the `trailingAnchor`
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.trailingAnchor
        } else {
            return self.trailingAnchor
        }
    }

    /// If the safe area is available, then the `safeAreaLayoutGuide.bottomAnchor`,
    /// otherwise the `bottomAnchor`
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }

    /// If the safe area is available, then the `safeAreaLayoutGuide.widthAnchor`,
    /// otherwise the `widthAnchor`
    var safeWidthAnchor: NSLayoutDimension {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.widthAnchor
        } else {
            return self.widthAnchor
        }
    }

    /// If the safe area is available, then the `safeAreaLayoutGuide.heightAnchor`,
    /// otherwise the `heightAnchor`
    var safeHeightAnchor: NSLayoutDimension {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.heightAnchor
        } else {
            return self.heightAnchor
        }
    }
}

// MARK: - UIView + Anchor

extension UIView {

    /// `leadingAnchor`
    /// - Parameter safe: `Bool` Use safe anchor
    func leadingAnchor(safe: Bool) -> NSLayoutXAxisAnchor {
        return safe ? safeLeadingAnchor : leadingAnchor
    }

    /// `trailingAnchor`
    /// - Parameter safe: `Bool` Use safe anchor
    func trailingAnchor(safe: Bool) -> NSLayoutXAxisAnchor {
        return safe ? safeTrailingAnchor : trailingAnchor
    }

    /// `topAnchor`
    /// - Parameter safe: `Bool` Use safe anchor
    func topAnchor(safe: Bool) -> NSLayoutYAxisAnchor {
        return safe ? safeTopAnchor : topAnchor
    }

    /// `bottomAnchor`
    /// - Parameter safe: `Bool` Use safe anchor
    func bottomAnchor(safe: Bool) -> NSLayoutYAxisAnchor {
        return safe ? safeBottomAnchor : bottomAnchor
    }

    /// `widthAnchor`
    /// - Parameter safe: `Bool` Use safe anchor
    func widthAnchor(safe: Bool) -> NSLayoutDimension {
        return safe ? safeWidthAnchor : widthAnchor
    }

    /// `heightAnchor`
    /// - Parameter safe: `Bool` Use safe anchor
    func heightAnchor(safe: Bool) -> NSLayoutDimension {
        return safe ? safeHeightAnchor : heightAnchor
    }
}

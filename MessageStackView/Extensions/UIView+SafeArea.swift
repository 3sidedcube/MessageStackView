//
//  UIView+SafeArea.swift
//  MessageStackView
//
//  Created by Ben Shutt on 25/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

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
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leadingAnchor
        } else {
            return self.leadingAnchor
        }
    }
    
    /// If the safe area is available, then the `safeAreaLayoutGuide.trailingAnchor`,
    /// otherwise the `trailingAnchor`
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
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
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.widthAnchor
        } else {
            return self.widthAnchor
        }
    }
    
    /// If the safe area is available, then the `safeAreaLayoutGuide.heightAnchor`,
    /// otherwise the `heightAnchor`
    var safeHeightAnchor: NSLayoutDimension {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.heightAnchor
        } else {
            return self.heightAnchor
        }
    }
}

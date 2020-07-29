//
//  UIApplication+StatusBar.swift
//  MessageStackView
//
//  Created by Ben Shutt on 08/05/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

extension UIApplication {

    /// `CGRect` frame of the Status Bar
    var appStatusBarFrame: CGRect {
        guard #available(iOS 13, *) else {
            // If not iOS 13 simply return `statusBarFrame`
            return statusBarFrame
        }
        
        // Otherwise find the key window and get frame from the scene
        return appKeyWindow?.windowScene?.statusBarManager?
            .statusBarFrame ?? .zero
    }
}

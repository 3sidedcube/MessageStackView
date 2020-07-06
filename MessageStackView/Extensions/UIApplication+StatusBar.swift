//
//  UIApplication+StatusBar.swift
//  Blood
//
//  Created by Ben Shutt on 08/05/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

extension UIApplication {
    
    /// `CGRect` frame of the Status Bar
    var appStatusBarFrame: CGRect {
        guard #available(iOS 13, *) else {
            return statusBarFrame
        }
        
        let window = windows.first { $0.isKeyWindow }
        return window?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
    }
}

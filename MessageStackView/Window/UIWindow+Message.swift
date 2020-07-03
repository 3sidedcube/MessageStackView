//
//  UIWindow+Message.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func post(message: Message) {
        
    }
}

extension UIWindow {
    func post(message: Message) {
        let messageStackView = MessageStackView()
        addSubview(messageStackView)
        
        
        
    }
}

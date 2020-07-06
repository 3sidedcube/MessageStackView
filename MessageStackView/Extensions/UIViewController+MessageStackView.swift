//
//  UIViewController+MessageStackView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// `MessageStackView` or create and constrain
    func messageStackViewOrCreate() -> MessageStackView {
        let messageStackView = view.messageStackViewOrCreate()
        messageStackView.spaceViewHeightConstraint.constant =
            UIApplication.shared.appStatusBarFrame.height
        return messageStackView
    }
}

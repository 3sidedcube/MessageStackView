//
//  UIButton+Extensions.swift
//  Example
//
//  Created by Ben Shutt on 25/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    @discardableResult
    static func addToCenter(
        of view: UIView,
        title: String,
        target: Any,
        selector: Selector
    ) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: selector, for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return button
    }
}

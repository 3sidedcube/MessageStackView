//
//  WindowViewController.swift
//  Example
//
//  Created by Ben Shutt on 08/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class WindowViewController: UIViewController {
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // `UIButton` top pop this `UIViewController` from `navigationController`
        // To show posted `UIView` is on the window
        UIButton.addToCenter(
            of: view,
            title: "Pop",
            target: self,
            selector: #selector(buttonTouchUpInside)
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.postViewOrCreate()?.post(badgeMessage:
            BadgeMessage(
                title: "This is a window notification",
                subtitle: "This notification has been posted on the key window",
                image: UIImage(named: "donations"),
                fillColor: .red
            )
        )
    }
    
    @objc private func buttonTouchUpInside(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

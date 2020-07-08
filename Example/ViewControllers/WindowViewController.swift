//
//  WindowViewController.swift
//  Example
//
//  Created by Ben Shutt on 08/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class WindowViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.postViewOrCreate()?.post(badgeMessage:
            BadgeMessage(
                title: "This is a window notification",
                subtitle: "This notification has been posted on the key window",
                image: UIImage(named: "donations"),
                fillColor: .green
            )
        )
    }
    
}

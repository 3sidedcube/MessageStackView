//
//  BadgeMessageViewController.swift
//  Example
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class BadgeMessageViewController: UIViewController {
    
    /// Arrray of titles for `badgeMessages` to demo
    private let badgeTitles: [(title: String, subtitle: String)] = [
        ("Badge Earned!", "That's a badge unlock"),
        ("Badge Earned Again!", "That's another badge unlock"),
        ("Badge Earned Again And Again!", "That's yet another badge unlock")
    ]
    
    /// `BadgeMessage`s from ``badgeTitles`
    private var badgeMessages: [BadgeMessage] {
        return badgeTitles.map {
            BadgeMessage(
                title: $0.title,
                subtitle: $0.subtitle,
                image: UIImage(named: "donations"),
                fillColor: .red
            )
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        badgeMessages.forEach {
            postViewOrCreate().post(badgeMessage: $0)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postViewOrCreate().postManager.invalidate()
    }
}

// MARK: - UIColor + Colors

private extension UIColor {
    
    /// Override `.red` color
    static let red = UIColor(
        red: 231/255, green: 19/255, blue: 36/255, alpha: 1
    )
}

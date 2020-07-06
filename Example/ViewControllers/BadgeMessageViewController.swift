//
//  BadgeMessageViewController.swift
//  Example
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class BadgeMessageViewController: UIViewController {
    
    /// `BadgeMessageView`
    private lazy var badgeMessageView: BadgeMessageView = {
        let badgeMessageView = BadgeMessageView()
        badgeMessageView.set(
            title: "Badge Earned!",
            subtitle: "Hat Trick",
            image: UIImage(named: "donations"),
            fillColor: .red
        )
        badgeMessageView.button.addTarget(
            self,
            action: #selector(buttonTouchUpInside),
            for: .touchUpInside
        )
        return badgeMessageView
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let messageStackView = messageStackViewOrCreate()
        messageStackView.layoutIfNeeded()
        messageStackView.post(view: badgeMessageView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        messageStackViewOrCreate().remove(view: badgeMessageView)
    }
    
    // MARK: - UIControlEvents
    
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        messageStackViewOrCreate().remove(view: badgeMessageView)
    }
}

// MARK: - UIColor + Colors

private extension UIColor {
    
    /// Override `.red` color
    static let red = UIColor(
        red: 231/255, green: 19/255, blue: 36/255, alpha: 1
    )
}

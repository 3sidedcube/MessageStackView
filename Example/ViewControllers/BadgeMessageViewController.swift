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
    
    /// Arrray of titles for `badgeMessages` to demo
    private let badgeTitles: [(title: String, subtitle: String)] = [
        ("Badge Earned!", "Hat Trick"),
        ("Badge Earned Again!", "Another Hat Trick"),
        ("Badge Earned Again And Again!", "Another Another Hat Trick")
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
    
    /// PostView
    private lazy var postView = PostView()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //postView.backgroundColor = .gray
        
        view.addSubview(postView)
        postView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            postView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            postView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        badgeMessages.forEach {
            let badgeMessageView = postView.post(badgeMessage: $0)
            badgeMessageView.button.addTarget(
                self,
                action: #selector(buttonTouchUpInside),
                for: .touchUpInside
            )
            
            // Add pan gesture
            let gestureManager = postView.postManager.gestureManager
            gestureManager.addPanToRemoveGesture(to: badgeMessageView)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postView.postManager.invalidate()
    }
    
    // MARK: - UIControlEvents
    
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        postView.postManager.removeCurrent()
    }
}

// MARK: - UIColor + Colors

private extension UIColor {
    
    /// Override `.red` color
    static let red = UIColor(
        red: 231/255, green: 19/255, blue: 36/255, alpha: 1
    )
}

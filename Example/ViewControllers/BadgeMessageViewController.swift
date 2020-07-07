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
    
    private let badges: [(title: String, subtitle: String)] = [
        ("Badge Earned!", "Hat Trick"),
        ("Badge Earned Again!", "Another Hat Trick"),
        ("Badge Earned Again And Again!", "Another Another Hat Trick")
    ]
    
    private lazy var postView = PostView()
    
    /// `BadgeMessageView`
    private func badgeMessageView(title: String, subtitle: String) -> BadgeMessageView {
        let badgeMessageView = BadgeMessageView()
        badgeMessageView.set(
            title: title,
            subtitle: subtitle,
            image: UIImage(named: "donations"),
            fillColor: .red
        )
        badgeMessageView.button.addTarget(
            self,
            action: #selector(buttonTouchUpInside),
            for: .touchUpInside
        )
        return badgeMessageView
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postView.backgroundColor = .gray
        
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
        
        badges.forEach {
            let view = badgeMessageView(title: $0.title, subtitle: $0.subtitle)
            
            postView.postManager.post(postRequest: PostRequest(
                view: view,
                dismissAfter: 10,
                animated: .both
            ))
            postView.postManager.gestureManager.addPanToRemoveGesture(
                to: view
            )
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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

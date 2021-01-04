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

/// `UIViewController` to demo posting a `BadgeMessage` on a `PostView`
class BadgeMessageViewController: UIViewController {

    /// `PostView` for posting messages
    private lazy var postView = view.createPostView()

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
                image: .donations,
                fillColor: .red
            )
        }
    }

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        UIButton.addToCenter(
            of: view,
            title: "Post with updated insets",
            target: self,
            selector: #selector(buttonTouchUpInside)
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        badgeMessages.forEach {
            postView.post(badgeMessage: $0)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        postView.postManager.invalidate()
    }

    // MARK: - Actions

    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        postView.edgeInsets = UIEdgeInsets(
            top: 3, left: 10, bottom: 3, right: 10
        )

        _ = postView.post(badgeMessage: BadgeMessage(
            title: "\(PostView.self) Insets Updated",
            subtitle: "The insets (margins) have been updated on the \(PostView.self)",
            image: .donations,
            fillColor: .blue
        ))
    }
}

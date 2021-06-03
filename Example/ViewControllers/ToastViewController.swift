//
//  ToastViewController.swift
//  Example
//
//  Created by Ben Shutt on 02/06/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

/// `UIViewController` to test `Toast`
class ToastViewController: UIViewController {

    /// `Toast` to post at the bottom of the screen
    private lazy var toast = Toast()

    /// `UIButton` to add to bottom to make sure it can be clicked when the toast is slowing
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(.buttonTitleClick, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(
            self,
            action: #selector(buttonTouchUpInside),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addButtonToBottomLeading()
        addAndConstrainToast(toast)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        toast.post(message: .shortMessage)
        toast.postIfNotShowing(message: .shortMessage) // Shouldn't show
        toast.post(message: .longMessage)
    }

    // MARK: - Subviews

    private func addButtonToBottomLeading() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
    }

    // MARK: - Actions

    /// `sender` received `.touchUpInside` `UIControl.Event`
    ///
    /// - Parameter sender: `UIButton` that invoked the action
    @objc
    private func buttonTouchUpInside(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.autoreverse],
            animations: {
                sender.setTitle(.buttonTitleClicked, for: .normal)
                sender.transform = CGAffineTransform(scaleX: 2, y: 2)
            }, completion: { _ in
                sender.transform = .identity
                sender.setTitle(.buttonTitleClick, for: .normal)
            }
        )
    }
}

// MARK: - String + Text

private extension String {

    static let buttonTitleClick = """
        Click Me
        """

    static let buttonTitleClicked = """
        Clicked!
        """

    static let shortMessage = """
        This is a toast!
        """

    static let longMessage = """
        This is a long toast to test how the text wraps when the width \
        of the text is greater than the width of the screen
        """
}

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

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        toast.addTo(
            view: view,
            layout: .bottom,
            constrainToSafeArea: true
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        toast.post(message: .shortMessage)
        toast.post(message: .longMessage)
    }
}

// MARK: - String + Text

private extension String {

    static let shortMessage = """
        This is a toast!"
        """

    static let longMessage = """
        This is a long toast to test how the text wraps when the width \
        of the text is greater than the width of the screen
        """
}

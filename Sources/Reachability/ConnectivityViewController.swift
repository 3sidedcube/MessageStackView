//
//  ConnectivityViewController.swift
//  MessageStackView
//
//  Created by Ben Shutt on 24/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ConnectivityViewController

/// `UIViewController` which conforms to `ConnectivityMessageable`
open class ConnectivityViewController: UIViewController, ConnectivityMessageable {

    /// `MessageLayout` when creating `messageStackView`
    open var messageLayout: MessageLayout {
        return .bottom
    }

    /// `MessageStackView` at the bottom of the screen
    public private(set) lazy var messageStackView = MessageStackView()

    // MARK: - Deinit

    deinit {
        messageStackView.postManager.invalidate()
    }

    // MARK: - ViewController lifecycle

    override open func viewDidLoad() {
        super.viewDidLoad()

        messageStackView.addTo(
            view: view,
            layout: messageLayout,
            constrainToSafeArea: false // Inset spaceView height
        )
        messageStackView.order = messageLayout.toOrder()
        view.setNeedsLayout()
    }

    override open func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        messageStackView.spaceViewHeight = safeAreaInset
    }

    // MARK: - SafeArea

    /// Safe area inset of `messageParentView`
    var safeAreaInset: CGFloat {
        switch messageLayout {
        case .top: return view.safeAreaInsets.top
        case .bottom: return view.safeAreaInsets.bottom
        }
    }
}

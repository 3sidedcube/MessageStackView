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

/// Base `UIViewController` for internet connection toasts in response to
/// Reachability `Notification`s.
///
/// - Warning:
/// While `UIViewController` is the base of a `UIViewController`s (obviously), subclassing
/// `ConnectivityViewController` is not so straight forward, e.g. `UITableViewController`.
///
/// If you want the "No internet" message toast to persist between screens, you can use post on a
/// `UIWindow` or a `UINavigationController` `view`.
/// Of course persisting within these bounds. Animation can be achieved using:
/// `transitionCoordinator?.animate(alongsideTransition:)`
///
open class ConnectivityViewController: UIViewController,
    InternetConnectionMessageable {

    /// `MessageStackView` at the bottom of the screen
    public private(set) lazy var messageStackView: MessageStackView = {
        return createMessageStackView()
    }()
    
    /// Observer for internet connectivity `Notification`s
    public var observer: NSObjectProtocol? = nil
    
    // MARK: - ViewController lifecycle
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewWillAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onViewWillDisappear()
    }

    open override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        onViewSafeAreaInsetsDidChange()
    }
}

// MARK: - InternetConnectionMessageable + UIViewController

extension InternetConnectionMessageable where Self: UIViewController {
    
    public var messageParentView: UIView {
        return view
    }
}


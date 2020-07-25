//
//  InternetConnectionNavigationController.swift
//  MessageStackView
//
//  Created by Ben Shutt on 25/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// Base `UINavigationController` for internet connection toasts in response to
/// Reachability `Notification`s
open class InternetConnectionNavigationController: UINavigationController,
    InternetConnectionMessageable {

    /// `MessageStackView` at the bottom of the screen
    public private(set) lazy var messageStackView: MessageStackView = {
        return createMessageStackView()
    }()
    
    /// Observer for internet connectivity `Notification`s
    public var observer: NSObjectProtocol? = nil
    
    // MARK: - ViewController lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
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

extension InternetConnectionNavigationController:
    UINavigationControllerDelegate {
    
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController, animated: Bool
    ) {
        didUpdateSafeArea()
    }
    
    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        // do nothing
    }
}

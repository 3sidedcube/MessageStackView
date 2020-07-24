//
//  ConnectivityTableViewController.swift
//  MessageStackView
//
//  Created by Ben Shutt on 24/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ConnectivityTableViewController

/// Base class for internet connection toasts in response to Reachability `Notification`s
open class ConnectivityTableViewController: UITableViewController,
    InternetConnectionMessageable {
    
    /// Since we are in a `UITableViewController`, where `view` is a `UITableView`,
    /// we need a child container `UIViewController` to layout the `messageStackView`
    private lazy var containerViewController = UIViewController()
    
    /// Pass on the parent of `messageStackView` to the child `UIViewController`
    public var messageParentView: UIView {
        return containerViewController.view
    }

    /// `MessageStackView` at the bottom of the screen
    public private(set) lazy var messageStackView: MessageStackView = {
        return createMessageStackView()
    }()
    
    /// Observer for internet connectivity `Notification`s
    public var observer: NSObjectProtocol? = nil
    
    // MARK: - ViewController lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(containerViewController)
        view.addSubview(containerViewController.view)
        containerViewController.didMove(toParent: self)
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
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        let safeInsets = view.safeAreaInsets
        containerViewController.additionalSafeAreaInsets = safeInsets
        
        guard let childView = containerViewController.view else {
            return
        }
        
        var frame = childView.frame
        frame.size.height = messageStackView.frame.height
        frame.size.width = view.bounds.width
        frame.origin.x = 0
        frame.origin.y = view.bounds.height - frame.height +
            tableView.contentOffset.y
        childView.frame = frame
        childView.superview?.bringSubviewToFront(childView)
        
        tableView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: frame.height,
            right: 0
        )
    }
}

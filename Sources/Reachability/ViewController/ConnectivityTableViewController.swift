//
//  ConnectivityTableViewController.swift
//  MessageStackView
//
//  Created by Ben Shutt on 24/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

class SubViewController: UIViewController {
    
    let messageLayout: MessageLayout
    
    init(messageLayout: MessageLayout) {
        self.messageLayout = messageLayout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// `MessageStackView` at the bottom of the screen
    fileprivate lazy var messageStackView: MessageStackView = {
        let messageStackView: MessageStackView = view.createPosterView(
            layout: .bottom,
            constrainToSafeArea: false
        )
        messageStackView.updateOrderForLayout(.bottom)
        return messageStackView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - ConnectivityViewController

/// Base class for internet connection toasts in response to Reachability `Notification`s
open class ConnectivityTableViewController: UITableViewController,
    InternetConnectionMessageable {
    
    private lazy var subViewController = SubViewController(
        messageLayout: messageLayout
    )

    /// `MessageStackView` at the bottom of the screen
    public private(set) lazy var messageStackView: MessageStackView = {
        return subViewController.messageStackView
    }()
    
    /// Observer for internet connectivity `Notification`s
    public var observer: NSObjectProtocol? = nil
    
    // MARK: - ViewController lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(subViewController)
        view.addSubview(subViewController.view)
        subViewController.didMove(toParent: self)
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
        
        var frame = subViewController.view.frame
        
        frame.size.height = messageStackView.frame.height
        frame.origin.x = 0
        frame.origin.y = view.bounds.height - frame.height - view.safeAreaInsets.t
        frame.size.width = view.bounds.width
        
        subViewController.view.frame = frame
    }
}

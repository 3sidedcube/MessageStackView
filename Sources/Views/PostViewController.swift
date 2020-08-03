//
//  PostViewController.swift
//  MessageStackView
//
//  Created by Ben Shutt on 02/08/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// `UIViewController` with a `PostView` intended to be used as the
/// `rootViewController` of a `PostWindow`
///
/// - TODO: This file is a WIP
class PostViewController: UIViewController {
    
    /// Shared `PostViewController` singleton instance
    static let shared = PostViewController()
    
    /// Add `PostViewController` to own `UIWindow`
    private(set) lazy var window: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .statusBar + 1
        window.rootViewController = self
        window.backgroundColor = .clear
        return window
    }()
    
    /// `PostView` added to the `.top` of `self`
    private(set) lazy var postView = PostView()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        window.isHidden = true
        
        postView.postManager.delegate = self
        postView.addTo(
            view: view,
            layout: .top,
            constrainToSafeArea: false
        )
    }
}

// MARK: - PostManagerDelegate

extension PostViewController: PostManagerDelegate {
    
    func postManager(
        _ postManager: PostManager,
        willPost view: UIView
    ) {
        window.isHidden = false
        self.view.layoutIfNeeded()
    }
    
    func postManager(
        _ postManager: PostManager,
        didRemove view: UIView
    ) {
        guard !postView.isActive else { return }
        window.isHidden = true
    }
}

//
//  InternetConnectionMessageable.swift
//  MessageStackView
//
//  Created by Ben Shutt on 24/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

// MARK: - InternetConnectionMessageable

/// Defines a behavior to post internet connected/disconnected messages in responce to
/// `Reachability` notifications.
///
/// Commonly used to define a shared behavior on system `UIViewController`s
/// (e.g. `UIViewController` and `UITableViewController`)
public protocol InternetConnectionMessageable: class {
    
    /// Superview `UIView` of the `MessageStackView`.
    /// I.e. `UIView` to add `MessageStackView` to.
    var messageParentView: UIView { get }
    
    /// Where to position the `MessageStackView`
    var messageLayout: MessageLayout { get }
    
    /// The `MessageStackView` to post messages on
    var messageStackView: MessageStackView { get }
    
    /// Observer added the the `.default` `NotificationCenter` responding to
    /// `Reachability` notifications
    var observer: NSObjectProtocol? { get set }
}

// MARK: - InternetConnectionMessageable + Functionality

public extension InternetConnectionMessageable {
    
    // MARK: - Defaults
    
    var messageLayout: MessageLayout {
        return .bottom
    }
    
    // MARK: - Lifecycle
    
    /// Call on `viewWillAppear(_:)`
    func onViewWillAppear() {
        observer = ConnectivityManager.shared.addObserver { [weak self] state in
            self?.didUpdateState(state: state)
        }
    }
    
    /// Call on `viewWillDisappear(_:)`
    func onViewWillDisappear() {
        if let observer = observer {
            ConnectivityManager.shared.removeObserver(observer)
        }
    }
    
    /// Call on `viewSafeAreaInsetsDidChange()`
    func onViewSafeAreaInsetsDidChange() {
        didUpdateSafeArea()
    }
    
    // MARK: - Functionality
    
    /// Create the `MessageStackView`
    func createMessageStackView() -> MessageStackView {
        let superview = messageParentView
        let messageStackView: MessageStackView = superview.createPosterView(
            layout: messageLayout,
            constrainToSafeArea: false
        )
        messageStackView.updateOrderForLayout(messageLayout)
        return messageStackView
    }
    
    // MARK: - SafeArea
    
    /// Update `spaceViewHeight` of `MessageStackView` with the `safeAreaInset`
    private func didUpdateSafeArea() {
        messageStackView.spaceViewHeight = safeAreaInset
    }
    
    /// Safe area inset of `messageParentView`
    private var safeAreaInset: CGFloat {
        switch messageLayout {
        case .top: return messageParentView.safeAreaInsets.top
        case .bottom: return messageParentView.safeAreaInsets.bottom
        }
    }
    
    // MARK: - State
    
    /// `ConnectivityManager.State` did update
    /// - Parameter state: `ConnectivityManager.State`
    func didUpdateState(state: ConnectivityManager.State) {
        if case .notConnected = state {
            postNoInternetMessage()
        } else {
            removeNoInternetMessage()
        }
    }
    
    // MARK: - Messages
    
    /// Post the "No Internet Connection" `Message`
    private func postNoInternetMessage() {
        didUpdateSafeArea() // Update before post
        
        let messageView = messageStackView.post(message: Message(
            title: "No Internet Connection",
            subtitle: "Please check your connection and try again",
            leftImage: .noInternet
        ))
        messageView.configureNoInternet()
    }
    
    /// Remove the "No Internet Connection" `Message`
    private func removeNoInternetMessage() {
        messageStackView.postManager.removeCurrent()
    }
}

// MARK: - InternetConnectionMessageable + UIViewController

extension InternetConnectionMessageable where Self: UIViewController {
    
    public var messageParentView: UIView {
        return view
    }
}

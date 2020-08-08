//
//  MessageManager.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

extension ConnectivityManager {
 
    /// Manage a `MessageStackView` to post "Not connected to internet" messages at the bottom
    /// of the `visibleViewController`s view.
    public class MessageManager: ConnectivityMessageable, PostManagerDelegate {

        /// `NSObjectProtocol` observing internet connection updates
        private var observer: NSObjectProtocol?
        
        /// `MessageStackView ` to post messages
        public private(set) lazy var messageStackView: MessageStackView = {
            let messageStackView = MessageStackView()
            messageStackView.updateOrderForLayout(.bottom)
            messageStackView.postManager.delegate = self
            return messageStackView
        }()
        
        /// `Message` to post when internet connectivity is lost
        public var message: Message = .noInternet {
            didSet {
                messageView?.set(message: message)
            }
        }
        
        /// `MessageView` posted when internet connectivity was lost
        ///
        /// - Warning:
        /// `messageView` is not necessarily posted on `messageStackView`,
        /// if the `visibleViewController` conforms to `InternetConnectivityMessageable`
        /// then it will post on there instead
        private weak var messageView: MessageView?
        
        // MARK: - Init
        
        deinit {
            stopObserving()
        }
        
        // MARK: - Connection Observer
        
        /// Add observer to `ConnectivityManager`
        public func startObserving() {
            guard observer == nil else { return }
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(viewWillDisappear),
                name: .viewWillDisappear,
                object: nil
            )
            
            observer = ConnectivityManager.shared.addObserver { [weak self] state in
                self?.didUpdateState(state)
            }
        }
        
        /// Remove observer from `ConnectivityManager`
        public func stopObserving() {
            guard let observer = observer else { return }
            
            ConnectivityManager.shared.removeObserver(observer)
            
            NotificationCenter.default.removeObserver(
                self,
                name: .viewWillDisappear,
                object: nil
            )
        }
        
        // MARK: - State
        
        /// `ConnectivityManager.State` did update
        /// - Parameter state: `ConnectivityManager.State`
        private func didUpdateState(_ state: ConnectivityManager.State) {
            if state.isConnected {
                onConnected()
            } else {
                onDisconnected()
            }
        }
        
        // MARK: - Connection Lifecycle
        
        /// Handle internet connection disconnected
        private func onDisconnected() {
            invalidateMessageStackView()
            
            guard let visibleViewController =
                UIApplication.shared.visibleViewController,
                var visibleView = visibleViewController.view else {
                    return
            }
        
            // If the `visibleViewController` conforms to `ConnectivityMessageable`
            // then send the message there!
            if let messageable = visibleViewController as? ConnectivityMessageable {
                post(to: messageable)
                return
            }
            
            // TODO: Can we avoid? Usually would have a `UITableViewController`
            // child inside a `UIViewController` parent.
            // For `UITableViewController`, add to `view` of `navigationController`.
            // WARNING: This relies on having a `navigationController`
            if visibleViewController is UITableViewController {
                visibleView = visibleViewController.navigationController?.view ??
                    visibleViewController.tabBarController?.view ?? visibleView
            }
            
            messageStackView.addTo(
                view: visibleView,
                layout: .bottom,
                constrainToSafeArea: false
            )
            messageStackView.spaceViewHeight =
                visibleViewController.view.safeAreaInsets.bottom
            
            visibleView.layoutIfNeeded()
            messageStackView.layoutIfNeeded()
            
            post(to: self)
        }
        
        /// Handle internet connection connected
        private func onConnected() {
            removeMessageStackView(animated: true)
        }
        
        // MARK: - MessageStackView
        
        /// Remove the `messageStackView` from its superview
        /// - Parameter animated: `Bool`
        private func removeMessageStackView(animated: Bool) {
            guard let messageView = messageView,
                let messageStackView = messageView.superview as? MessageStackView else {
                    invalidateMessageStackView()
                    return
            }
            
            messageStackView.postManager.remove(
                view: messageView,
                animated: animated
            )
        }
        
        /// - Invalidate `postManager` of `messageStackView`
        /// - Remove `messageStackView` from its superview
        private func invalidateMessageStackView() {
            messageStackView.postManager.invalidate()
            messageStackView.removeFromSuperview()
        }
        
        /// `UIViewController` lifecycle event
        /// - Parameter sender: `Notification`
        @objc private func viewWillDisappear(_ sender: Notification) {
            removeMessageStackView(animated: true)
        }
        
        // MARK: - Post
        
        /// Post internet connectivity lost on the given `messageable`
        /// 
        /// - Parameter messageable: `ConnectivityMessageable`
        private func post(to messageable: ConnectivityMessageable) {
            guard messageable.messageManagerShouldPost(self) else {
                return
            }
            
            let messageView = messageable.messageStackView.post(
                message: messageable.message,
                dismissAfter: messageable.dismissAfter,
                animated: messageable.postAnimation
            )
            
            messageView.configureNoInternet()
            self.messageView = messageView
            
            messageable.messageManager(self, didPostMessageView: messageView)
        }
        
        // MARK: - PostManagerDelegate
        
        public func postManager(
            _ postManager: PostManager,
            didRemove view: UIView
        ) {
            guard !postManager.isActive else { return }
            invalidateMessageStackView()
        }
    }
}

// MARK: - Message + ConnectivityManager.MessageManager

public extension Message {
    
    /// Default `Message` to post when internet connectivity is lost
    static var noInternet: Message {
        return Message(
            title: "No Internet Connection",
            subtitle: "Please check your connection and try again",
            leftImage: .noInternet,
            rightImage: nil
        )
    }
}

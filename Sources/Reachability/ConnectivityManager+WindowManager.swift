//
//  WindowManager.swift
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
    public class InternetMessageManager {

        /// `NSObjectProtocol` observing internet connection updates
        private var observer: NSObjectProtocol?
        
        /// `MessageStackView ` to post messages
        private lazy var messageStackView: MessageStackView = {
            let messageStackView = MessageStackView()
            messageStackView.updateOrderForLayout(.bottom)
            return messageStackView
        }()
        
        /// `MessageConfiguration`
        public var messsageConfiguration = MessageConfiguration()
        
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
            self.messageStackView.postManager.removeCurrent()
            self.messageStackView.removeFromSuperview()
            
            guard let visibleViewController =
                UIApplication.shared.visibleViewController,
                var visibleView = visibleViewController.view else {
                    return
            }
            
            // TODO: Handle visible system viewControllers like `UIAlertController`

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
            
            let messageView = messageStackView.post(message: Message(
                title: noInternetTitle,
                subtitle: noInternetSubtitle,
                leftImage: noInternetImage
            ))
            messageView.configureNoInternet()
        }
        
        /// Handle internet connection connected
        private func onConnected() {
            removeMessageStackView(animated: true)
        }
        
        // MARK: - MessageStackView
        
        /// Remove the `messageStackView` from its superview
        /// - Parameter animated: `Bool`
        private func removeMessageStackView(animated: Bool) {
            guard let _ = messageStackView.superview else {
                messageStackView.postManager.removeCurrent()
                return
            }
            
            messageStackView.layoutIfNeeded()
            UIView.animate(
                withDuration: animated ? .animationDuration : 0,
                animations: {
                    self.messageStackView.postManager.removeCurrent()
                    self.messageStackView.layoutIfNeeded()
            }) { _ in
                self.messageStackView.removeFromSuperview()
            }
        }
        
        /// `UIViewController` lifecycle event
        /// - Parameter sender: `Notification`
        @objc private func viewWillDisappear(_ sender: Notification) {
            removeMessageStackView(animated: true)
        }
    }
}

// MARK: - Configuration

extension ConnectivityManager.InternetMessageManager {
    
    /// Configuration of `ConnectivityManager`
    public struct MessageConfiguration {
        
        /// When non-`nil`, override default "No internet connection" toast title
        public var title: String?
        
        /// When non-`nil`, override default "No internet connection" toast subtitle
        public var subtitle: String?
        
        /// When non-`nil`, override default "No internet connection" toast image
        public var image: UIImage?
        
        /// Default public memberwise initializer
        ///
        /// - Parameters:
        ///   - title: `String?`
        ///   - subtitle: `String?`
        ///   - image: `UIImage?`
        public init(
            title: String? = nil,
            subtitle: String? = nil,
            image: UIImage? = nil
        ){
            self.title = title
            self.subtitle = subtitle
            self.image = image
        }
    }
    
    private var noInternetTitle: String {
        return messsageConfiguration.title ?? "No Internet Connection"
    }
    
    private var noInternetSubtitle: String {
        return messsageConfiguration.subtitle ??
            "Please check your connection and try again"
    }
    
    private var noInternetImage: UIImage? {
        return messsageConfiguration.image ?? .noInternet
    }
}

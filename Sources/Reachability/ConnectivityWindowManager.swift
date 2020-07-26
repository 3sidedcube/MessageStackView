//
//  ConnectivityWindowManager.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

public class ConnectivityWindowManager {
    
    /// `ConnectivityWindowManager`
    public static let shared = ConnectivityWindowManager()
    
    /// `NSObjectProtocol`
    private var observer: NSObjectProtocol?
    
    /// `MessageStackView `
    private lazy var messageStackView: MessageStackView = {
        let messageStackView = MessageStackView()
        messageStackView.updateOrderForLayout(.bottom)
        return messageStackView
    }()
    
    // MARK: - Init
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewWillDisappear),
            name: .viewWillDisappear,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .viewWillDisappear,
            object: nil
        )
    }
    
    // MARK: - Observer
    
    /// Add observer to `ConnectivityManager`
    public func startObserving() {
        guard observer == nil else { return }
        observer = ConnectivityManager.shared.addObserver { [weak self] state in
            self?.didUpdateState(state)
        }
    }
    
    /// Remove observer from `ConnectivityManager`
    public func stopObserving() {
        guard let observer = observer else { return }
        ConnectivityManager.shared.removeObserver(observer)
    }
    
    // MARK: - State
    
    private func didUpdateState(_ state: ConnectivityManager.State) {
        if state.isConnected {
            onConnected()
        } else {
            onDisconnected()
        }
    }
    
    // MARK: - Connection Lifecycle
    
    private func onDisconnected() {
        self.messageStackView.postManager.removeCurrent()
        self.messageStackView.removeFromSuperview()
        
        guard let visibleViewController =
            UIApplication.shared.visibleViewController,
            var visibleView = visibleViewController.view else {
                return
        }
        
        if visibleViewController is UITableViewController {
            visibleView = visibleViewController.navigationController?.view ??
            visibleView
        }
        
        messageStackView.addTo(
            view: visibleView,
            layout: .bottom,
            constrainToSafeArea: false
        )
        messageStackView.spaceViewHeight = visibleView.safeAreaInsets.bottom
        
        visibleView.layoutIfNeeded()
        messageStackView.layoutIfNeeded()
        
        let messageView = messageStackView.post(message: Message(
            title: "No Internet Connection",
            subtitle: "Please check your connection and try again",
            leftImage: .noInternet
        ))
        messageView.configureNoInternet()
    }
    
    private func onConnected() {
        removeMessageStackView(animated: true)
    }
    
    // MARK: - MessageStackView
    
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
    
    @objc private func viewWillDisappear(_ sender: Notification) {
        removeMessageStackView(animated: true)
    }
}

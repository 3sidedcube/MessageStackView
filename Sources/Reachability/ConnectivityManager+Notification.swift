//
//  ConnectivityManager+Notification.swift
//  MessageStackView
//
//  Created by Ben Shutt on 24/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

// MARK: - Notification.Name

public extension Notification.Name {
    
    /// `Notification.Name` for `ConnectivityManager` `Notfication`
    static let internetConnectivityChanged: Notification.Name = Notification.Name(
        rawValue: "messageStackView.internetConnectivityChanged"
    )
}

// MARK: - ConnectivityManager + Notification

/// `Notification` related `ConnectivityManager` functionality
public extension ConnectivityManager {
    
    /// `String` key in the `Notification` `userInfo` to find `State`
    static let userInfoKey = "messageStackView.connectivityManager.state"
    
    /// Post `Notification` on the `.default` `NotificationCenter` on
    /// `state` updated
    ///
    /// - Parameter state: `State`
    func postNotification(for state: State) {
        let key = ConnectivityManager.userInfoKey
        
        NotificationCenter.default.post(
            name: .internetConnectivityChanged,
            object: self,
            userInfo: [key: state]
        )
    }
    
    /// Add `observer` to the `.default` `NotificationCenter` listening for
    /// internet connectivity `Notifiction`s
    ///
    /// - Parameters:
    ///   - observer: `Any`
    ///   - selector: `Selector`
    func addObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: .internetConnectivityChanged,
            object: self
        )
    }
    
    /// Remove `observer` from the `.default` `NotificationCenter` listening for
    /// internet connectivity `Notifiction`s
    ///
    /// - Parameters:
    ///   - observer: `Any`
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(
            observer,
            name: .internetConnectivityChanged,
            object: self
        )
    }
}

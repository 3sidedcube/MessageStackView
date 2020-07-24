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

/// Closure to execute on `Notification`
public typealias StateClosure = (ConnectivityManager.State) -> Void

/// `Notification` related `ConnectivityManager` functionality
public extension ConnectivityManager {
    
    /// `String` key in the `Notification` `userInfo` to find `State`
    static let stateUserInfoKey = "messageStackView.connectivityManager.state"
    
    /// Post `Notification` on the `.default` `NotificationCenter` on
    /// `state` updated
    ///
    /// - Parameter state: `State`
    func postNotification(for state: State) {
        let key = ConnectivityManager.stateUserInfoKey
        
        NotificationCenter.default.post(
            name: .internetConnectivityChanged,
            object: self,
            userInfo: [key: state]
        )
    }
    
    /// Add an observer to the `.default` `NotificationCenter` listening for
    /// internet connectivity `Notification`s. Execute `closure` on observation event.
    ///
    /// - Parameters:
    ///   - closure: ``StateClosure` `
    ///   - startListening: `Bool` invoke `startListening()`
    func addObserver(
        closure: @escaping StateClosure,
        startListening: Bool = true
    ) -> NSObjectProtocol {
        let observer = NotificationCenter.default.addObserver(
            forName: .internetConnectivityChanged,
            object: self,
            queue: .main
        ) { sender in
            let key = ConnectivityManager.stateUserInfoKey
            if let state = sender.userInfo?[key] as? State {
                closure(state)
            }
        }
        observers.append(observer)
        
        if startListening {
            self.startListening()
        }
        
        return observer
    }
    
    /// Remove `observer` from the `.default` `NotificationCenter` listening for
    /// internet connectivity `Notification`s
    ///
    /// - Parameters:
    ///   - observer: `NSObjectProtocol`
    ///   - stopListeningIfEmpty: `Bool` invoke `stopListening()` if there are no
    ///   more oberserves
    func removeObserver(
        _ observer: NSObjectProtocol,
        stopListeningIfEmpty: Bool = true
    ) {
        NotificationCenter.default.removeObserver(
            observer,
            name: .internetConnectivityChanged,
            object: self
        )
        
        observers.removeAll { $0 as AnyObject === observer }
        
        if stopListeningIfEmpty, observers.isEmpty {
            self.stopListening()
        }
    }
}

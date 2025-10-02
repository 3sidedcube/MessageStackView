//
//  ConnectivityManager.swift
//  MessageStackView
//
//  Created by Ben Shutt on 24/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.

import Foundation
import MessageStackViewObjC

// MARK: - ConnectivityManager

/// Simple Swift wrapper of `Reachability`.
/// Manage internet connection`Notification`s on connect and disconnect.
///
/// - TODO: Migrate to NWPathMonitor
public class ConnectivityManager {

    /// Internet connectivity state
    public enum State {

        /// Connected to the internet with `NetworkStatus`
        case connected(NetworkStatus)

        /// Not connected to the internet
        case notConnected
    }

    /// Shared singleton `ConnectivityManager` instance
    public static let shared = ConnectivityManager()

    /// Is listening for internet notification events
    private var isListening = false

    /// `Reachability` instance for internet connection
    private lazy var reachability = Reachability.forInternetConnection()

    /// Observers listening on the `.default` `NotificationCenter`
    internal var observers: [NSObjectProtocol] = [] {
        didSet {
            if !observers.isEmpty {
                startListening()
            } else if stopOnEmptyObservers {
                stopListening()
            }
        }
    }

    /// Log on `reachabilityChanged(_:)` `Notifications`
    public var logReachabilityChanged = false

    /// Disconnect when `observers` is empty
    public var stopOnEmptyObservers = true

    /// `MessageManager` instance.
    ///
    /// The `MessageManager` manages a `MessageStackView` to add and
    /// remove from the `visibleViewController` on Reachability internet connectivity
    /// events.
    public private(set) var messageManager = MessageManager()

    // MARK: - Init

    /// Default public initializer
    public init() {
    }

    deinit {
        stopListening()
    }

    // MARK: - Listen

    /// Start internet connectivity `Reachability` notifier and start listening for
    /// `.reachabilityChanged` `Notification`s
    public func startListening() {
        guard !isListening else { return }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged),
            name: .reachabilityChanged,
            object: nil
        )
        reachability?.startNotifier()

        isListening = true
    }

    /// Stop internet connectivity `Reachability` notifier and stop listening for
    /// `.reachabilityChanged` `Notification`s
    public func stopListening() {
        guard isListening else { return }

        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(
            self,
            name: .reachabilityChanged,
            object: nil
        )

        isListening = false
    }

    // MARK: - Notification

    /// `sender` sent when `NetworkStatus` changed on `reachability`
    /// - Parameter sender: `Notification`
    @objc
    private func reachabilityChanged(_ sender: Notification) {
        guard let reachability = sender.object as? Reachability else {
            return
        }

        let status = reachability.currentReachabilityStatus()
        let state = status.state

        if logReachabilityChanged {
            debugPrint("\(ConnectivityManager.self) \(#function) \(state)")
        }

        postNotification(for: state)
    }

    // MARK: - Observers

    /// Is the given `observer` contained in `observers`
    /// - Parameter observer: `NSObjectProtocol`
    public func isObserver(_ observer: NSObjectProtocol) -> Bool {
        return observers.contains { $0 === observer }
    }
}

// MARK: - NetworkStatus + ConnectivityManager.State

public extension NetworkStatus {

    /// `NetworkStatus` to `ConnectivityManager.State`
    var state: ConnectivityManager.State {
        switch self {
        case NotReachable: return .notConnected
        case ReachableViaWiFi: return .connected(self)
        case ReachableViaWWAN: return .connected(self)
        default: return .notConnected
        }
    }

    /// Description of the connection
    fileprivate var connectionDescription: String {
        switch self {
        case NotReachable: return "Not connected"
        case ReachableViaWiFi: return "WIFI"
        case ReachableViaWWAN: return "WWAN"
        default: return "Unknown"
        }
    }
}

// MARK: - ConnectivityManager.State + CustomStringConvertible

extension ConnectivityManager.State: CustomStringConvertible {

    public var description: String {
        switch self {
        case .connected(let networkStatus):
            return "Connected via \(networkStatus.connectionDescription)"
        case .notConnected:
            return "Not connected"
        }
    }
}

// MARK: - ConnectivityManager.State + Connected

public extension ConnectivityManager.State {

    /// Is `ConnectivityManager.State` considered connected
    var isConnected: Bool {
        switch self {
        case .connected: return true
        case .notConnected: return false
        }
    }
}

//
//  InternetConnectivityMessageable.swift
//  MessageStackView
//
//  Created by Ben Shutt on 24/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

// MARK: - InternetConnectionMessageable

/// An entity which conforms to `InternetConnectivityMessageable` defines a behavior to
/// recieve internet connected/disconnected messages in responce to `Reachability` notifications.
///
/// E.g. A `UIViewController` may already have a `MessageStackView` in it's view hierarchy,
/// so doesn't want another `MessageStackView` added by the shared `MessageManager`
public protocol InternetConnectivityMessageable: class {
    
    /// The `MessageStackView` to post `Message`s on
    var messageStackView: MessageStackView { get }
    
    /// `Message` to post on `messageStackView` when internet connectivity is lost
    var message: Message { get }
    
    /// `TimeInterval` `"dismissAfter"` argument when posting on `messageStackView`
    var dismissAfter: TimeInterval? { get }
    
    /// `PostAnimation` `"animated"` argument when posting on `messageStackView`
    var postAnimation: PostAnimation { get }
    
    /// Called when `messageManager` will post a `MessageView` on the `messageStackView`
    ///
    /// - Parameter messageManager: `ConnectivityManager.MessageManager`
    func messageManagerShouldPost(
        _ messageManager: ConnectivityManager.MessageManager
    ) -> Bool
    
    /// Called when `messageManager` posted  `messageView` on the `messageStackView`
    ///
    /// - Parameters:
    ///   - messageManager: `ConnectivityManager.MessageManager`
    ///   - messageView: `MessageView`
    func messageManager(
        _ messageManager: ConnectivityManager.MessageManager,
        didPostMessageView messageView: MessageView
    )
}

// MARK: - InternetConnectivityMessageable + Functionality

public extension InternetConnectivityMessageable {
  
    var message: Message {
        return .noInternet
    }
    
    var dismissAfter: TimeInterval? {
        return .defaultMessageDismiss
    }
    
    var postAnimation: PostAnimation {
        return .default
    }
    
    func messageManagerShouldPost(
        _ messageManager: ConnectivityManager.MessageManager
    ) -> Bool {
        return true
    }
    
    func messageManager(
        _ messageManager: ConnectivityManager.MessageManager,
        didPostMessageView messageView: MessageView
    ) {        
    }
}

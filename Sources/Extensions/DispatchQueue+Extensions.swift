//
//  DispatchQueue+Extensions.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    /// Execute `closure` after `time` from `.now()`
    /// - Parameters:
    ///   - time: `DispatchTimeInterval`
    ///   - closure: Closure to execute
    func asyncAfterNow(
        time: DispatchTimeInterval,
        closure: @escaping () -> Void
    ) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + time,
            execute: closure
        )
    }
    
    /// Execute `closure` on main thread or immediately if already on it.
    /// - Parameter closure: Closure to execute
    static func executeOnMain(execute closure: @escaping () -> Void) {
        if Thread.current.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async(execute: closure)
        }
    }
}

//
//  Array+Extensions.swift
//  MessageStackView
//
//  Created by Ben Shutt on 23/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.

import Foundation

public extension Array where Element: Equatable {
    
    /// Get the next `Element` after the first instance of `element`
    ///
    /// - Parameter element: `Element`
    func elementAfterFirst(of element: Element) -> Element? {
        guard let index = firstIndex(of: element), index < endIndex else {
            return nil
        }
        let newIndex = self.index(after: index)
        guard newIndex < endIndex else { return nil }
        return self[newIndex]
    }
    
    /// Get the previous `Element` before the first instance of `element`
    ///
    /// - Parameter element: `Element`
    func elementBeforeFirst(of element: Element) -> Element? {
        guard let index = firstIndex(of: element), index > startIndex else {
            return nil
        }
        let newIndex = self.index(before: index)
        return self[newIndex]
    }
    
}

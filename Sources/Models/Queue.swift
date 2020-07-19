//
//  Queue.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// ArrayDeque structure
struct Queue<Element> {
    
    /// `Array` of `Element`s in the `Queue`
    private var elements: [Element] = []
    
    /// Append `element` to the end of the `Queue`
    /// - Parameter element: `Element` to append
    mutating func enqueue(_ element: Element) {
        elements.append(element)
    }
    
    /// Remove the `Element` from the front of the queue
    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }
    
    /// `Element` at the front of the `Queue`
    var head: Element? {
        return elements.first
    }
    
    /// Element at the end of the `Queue`
    var tail: Element? {
        return elements.last
    }
    
    /// Number of elements in the `Queue`
    var count: Int {
        return elements.count
    }
    
    /// Returns `true` if the `Queue` doesn't have any elements.
    /// I.e. `elements` is empty.
    var isEmpty: Bool {
        return elements.isEmpty
    }
}

// MARK: - Sequence

extension Queue: Sequence {
    typealias Iterator = Array<Element>.Iterator
    typealias Element = Element
    
    __consuming func makeIterator() -> Array<Element>.Iterator {
        return elements.makeIterator()
    }
}

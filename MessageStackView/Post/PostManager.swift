//
//  PostManager.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

/// `PostManager` encapsulates the posting and removing of a `UIView`.
///
/// When a `UIView` is posted the caller may not want the `UIView` to show forever.
/// In this case,`PostManager` internally triggers a `Timer` to remove a `UIView` after a
/// specified `TimeInterval`.
///
/// Moreover, the caller may want to post in a serial manner.
/// `PostManager` internally stores a `Queue` of `PostRequest`s to handle them one at a time.
///
/// `PostManager` is responsible for the logic of when to post and remove `PostRequest`s.
/// The actual `UIView` posting and removing should be handled by the `UIViewPoster` passed
/// into `PostManager` in the initializer.
public class PostManager {
    
    /// `UIViewPoster` to handle the post and remove of a `PostRequest`
    private weak var poster: UIViewPoster?
    
    /// `PostManagerDelegate` for `PostManager` delegate callabacks
    public weak var delegate: PostManagerDelegate?
    
    /// `PostGestureManager` to manage `UIGestureRecognizer` actions
    /// to remove a `UIView`
    public private(set) lazy var gestureManager: PostGestureManager = {
        let gestureManager = PostGestureManager()
        gestureManager.delegate = self
        return gestureManager
    }()
    
    /// Map a posted `UIView` to a `Timer`s which triggers the removal of that
    /// `UIView` if it has a finite lifetime
    private var timerMap = [UIView: Timer]()
    
    /// `Queue` of `PostRequest`s when `isSerialQueue` is `true`.
    /// If `isSerialQueue` is set to `false`, `queue` is emptied and posts all
    /// pending `PostRequest`s.
    private var queue = Queue<PostRequest>()
    
    /// Should the posted `UIView`s be handled by a serial `Queue`, i.e. one at a time.
    /// If `true`, queued `PostRequest`s are stored in `queue`.
    private var isSerialQueue: Bool = true {
        didSet {
            guard !isSerialQueue else { return }
            while let postRequest = queue.dequeue() {
                post(postRequest: postRequest)
            }
        }
    }
    
    /// Currently executing `PostRequest`
    private var currentPostRequest: PostRequest?

    // MARK: - Init
    
    /// Initializer with `poster`
    /// - Parameter poster: `UIViewPoster`
    public init (poster: UIViewPoster) {
        self.poster = poster
    }
    
    /// Invalidate properties
    deinit {
        invalidate()
    }
    
    // MARK: - Invalidate
    
    /// Invalidate:
    /// - Remove `PostRequest`s
    /// - Clear `queue`
    /// - Invalidate `Timer`s
    public func invalidate() {
        // Invalidate `gestureManager`
        gestureManager.invalidate()
        
        // Remove `currentPostRequest`
        if let request = currentPostRequest {
            remove(view: request.view, animated: false)
        }
        currentPostRequest = nil
        
        // Empty and remove `queue`
        while let request = queue.dequeue() {
            remove(view: request.view, animated: false)
        }
        
        // Invalidate timers
        // These should theoretically be cleaned up from the remove methods,
        // but invalidate anyway to handle unexpected manipulation from caller
        timerMap.values.forEach {
            $0.invalidate()
        }
        timerMap = [UIView: Timer]()
    }
    
    // MARK: - Post
    
    /// Post the given `postRequest`.
    ///
    /// If `isSerialQueue`, ensure there is not a `currentPostRequest` otherwise
    /// add to `queue`.
    ///
    /// - Parameter postRequest: `PostRequest`
    public func post(postRequest: PostRequest) {
        // Check with the `poster` if the `view` of the `postRequest` is valid
        guard poster?.shouldPost(view: postRequest.view) ?? true else {
            return
        }
        
        // Add to queue if `isSerialQueue` and there is a `currentPostRequest`
        guard !isSerialQueue || currentPostRequest == nil else {
            queue.enqueue(postRequest)
            return
        }
        
        // Set `currentPostRequest`
        currentPostRequest = postRequest
        
        // Get `view` from the `postRequest`
        let view = postRequest.view
        
        // Remove from previous layout tree if it exists
        view.removeFromSuperview()
        
        // Execute `delegate` will post
        delegate?.postManager(self, willPost: view)
        
        // Inform `poster` to post
        poster?.post(
            view: view,
            animated: postRequest.animated.contains(.onPost),
            completion: {
                self.completePost(postRequest: postRequest)
        })
    }
    
    /// Invoke on the completion of `poster` posting a `view` of a `postRequest`.
    /// E.g. after an animation has completed.
    ///
    /// - Parameter postRequest: `PostRequest`
    private func completePost(postRequest: PostRequest) {
        // Time after post to dismiss, zero or `nil` to mean do not dismiss
        let dismissAfterTimeInterval = max(0, postRequest.dismissAfter ?? 0)
        
        // Stop here if the caller does not want to dismiss this message
        guard dismissAfterTimeInterval > 0 else {
            return
        }
        
        // `UIView` posted
        let view = postRequest.view
        
        // Should we animate the removal
        let animateRemove = postRequest.animated.contains(.onRemove)
        
        // Schedule timer to fire `remove` call
        timerMap[view] = Timer.scheduledTimer(
            withTimeInterval: dismissAfterTimeInterval,
            repeats: false
        ) { [weak view, weak self] timer in
            if let view = view, let self = self {
                self.remove(view: view, animated: animateRemove)
            }
        }
        
        // Execute `delegate` did post
        delegate?.postManager(self, didPost: view)
    }
    
    // MARK: - Remove
    
    /// Remove (unpost) a posted `view` invalidatating appropriate properties.
    /// - Parameters:
    ///   - view: `UIView` to remove
    ///   - animated: Should the removal be animated
    public func remove(view: UIView, animated: Bool = true) {
        // Remove gestures
        gestureManager.remove(view: view)
        
        // Remove pending removal timer
        timerMap[view]?.invalidate()
        timerMap[view] = nil
        
        // Ensure the context of the subview is still valid
        guard poster?.shouldRemove(view: view) ?? true else {
            return
        }
        
        // Execute `delegate` will remove
        delegate?.postManager(self, willRemove: view)
        
        // Inform `poster` to remove
        poster?.remove(view: view, animated: animated) {
            self.completeRemove(view: view)
        }
    }
    
    /// Invoke on the completion of `poster` removing `view`.
    /// - Parameter view: `UIView`
    private func completeRemove(view: UIView) {
        // Apple docs say the stackView will remove it from its
        // arrangedSubviews list automatically when calling this method
        view.removeFromSuperview()
        
        // No current
        currentPostRequest = nil
        
        // Execute `delegate` did remove
        delegate?.postManager(self, didRemove: view)
        
        // If the queue is non-empty, post the next
        if let postRequest = queue.dequeue() {
            post(postRequest: postRequest)
        }
    }
}

// MARK: - PostGestureManagerDelegate

extension PostManager: PostGestureManagerDelegate {
    
    func postGestureManager(
        _ manager: PostGestureManager,
        didRequestToRemoveView view: UIView
    ) {
        remove(view: view, animated: true) // TODO: PostRequest animated
    }
}

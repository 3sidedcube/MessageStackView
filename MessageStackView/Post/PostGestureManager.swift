//
//  PostGestureManager.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

protocol PostGestureManagerDelegate: class {
    
    func postGestureManager(
        _ manager: PostGestureManager,
        didRequestToRemoveView view: UIView
    )
}

public class PostGestureManager {
    
    /// `PostGestureManagerDelegate`
    weak var delegate: PostGestureManagerDelegate?
    
    /// Map `UIView`s to their "tap to dismiss" `UITapGestureRecognizer`
    private var tapGestureMap = [UIView: UITapGestureRecognizer]()
    
    /// Map `UIView`s to their "pan to dismiss" `UIPanGestureRecognizer`
    private var panGestureMap = [UIView: UIPanGestureRecognizer]()
    
    // MARK: - Deinit
    
    deinit {
        invalidate()
    }
    
    // MARK: - Invalidate
    
    func invalidate() {
        tapGestureMap.forEach {
            $0.key.removeGestureRecognizer($0.value)
        }
        panGestureMap.forEach {
            $0.key.removeGestureRecognizer($0.value)
        }
        
        tapGestureMap = [:]
        panGestureMap = [:]
    }
    
    // MARK: - Tap
    
    /// Add `UITapGestureRecognizer` to `view` to remove it from `self`
    /// - Parameter view: `UIView` to add gesture to
    public func addTapToRemoveGesture(to view: UIView) {
        guard tapGestureMap[view] == nil else {
            return
        }
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(viewTapped)
        )
        tapGestureMap[view] = tap
        view.addGestureRecognizer(tap)
    }
    
    /// Remove `UITapGestureRecognizer` from `view`
    /// - Parameter view: `UIView` to remove gesture from
    public func removeTapToRemoveGesture(from view: UIView) {
        guard let tap = tapGestureMap[view] else {
            return
        }
        
        tapGestureMap[view] = nil
        view.removeGestureRecognizer(tap)
    }
    
    /// When a `UIView` wants to be dismissed on tap.
    /// - Parameter sender: `UITapGestureRecognizer`
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended, let view = sender.view {
            requestRemove(view: view)
        }
    }
    
    // MARK: - Pan
    
    /// Add `UIPanGestureRecognizer` to `view` to remove it from `self`
    /// - Parameter view: `UIView` to add gesture to
    public func addPanToRemoveGesture(to view: UIView) {
        guard panGestureMap[view] == nil else {
            return
        }
        let tap = UIPanGestureRecognizer(
            target: self,
            action: #selector(viewPanned)
        )
        panGestureMap[view] = tap
        view.addGestureRecognizer(tap)
    }
    
    /// Remove `UIPanGestureRecognizer` from `view`
    /// - Parameter view: `UIView` to remove gesture from
    public func removePanToRemoveGesture(from view: UIView) {
        guard let tap = panGestureMap[view] else {
            return
        }
        
        panGestureMap[view] = nil
        view.removeGestureRecognizer(tap)
    }
    
    /// When a `UIView` wants to be dismissed on pan.
    /// - Parameter sender: `UIPanGestureRecognizer`
    @objc private func viewPanned(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        
        switch sender.state {
            
        // Pan did update
        case .changed:
            view.transform = CGAffineTransform(
                translationX: 0,
                y: min(0, sender.translation(in: view.superview).y)
            )
            return
            
        // Pan did finish
        case .ended:
            let translateY = view.transform.ty
            let centerY = view.center.y
            
            let finalY = centerY + translateY
            if finalY < 0 {
                requestRemove(view: view)
                return
            }
            
        // Other
        default:
            break
        }
        
        UIView.animate(withDuration: .animationDuration) {
            view.transform = .identity
        }
    }
    
    // MARK: - Remove
    
    /// `UIView` should be removed based on gesture
    /// - Parameter view: `UIView` to remove
    private func requestRemove(view: UIView) {
        remove(view: view)
        delegate?.postGestureManager(self, didRequestToRemoveView: view)
    }
    
    /// Remove references to gestures for `view`
    /// - Parameter view: `UIView`
    func remove(view: UIView) {
        tapGestureMap[view] = nil
        panGestureMap[view] = nil
    }
}

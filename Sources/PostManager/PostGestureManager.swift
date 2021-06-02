//
//  PostGestureManager.swift
//  MessageStackView
//
//  Created by Ben Shutt on 06/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

/// Delegate callbacks for `PostGestureManager`
protocol PostGestureManagerDelegate: AnyObject {

    func postGestureManager(
        _ manager: PostGestureManager,
        didRequestToRemoveView view: UIView
    )

    func postGestureManager(
        _ manager: PostGestureManager,
        didStartPanGestureForView view: UIView
    )

    func postGestureManager(
        _ manager: PostGestureManager,
        didEndPanGestureForView view: UIView
    )
}

/// Manage gestures for posted `UIView`s to trigger a removal of that posted `UIView`.
/// 
/// E.g. The user pans a view off the top wanting for it to be dimissed.
/// E.g. T user tapped to dismiss
public class PostGestureManager {

    /// `PostGestureManagerDelegate`
    weak var delegate: PostGestureManagerDelegate?

    /// Map `UIView`s to their "tap to dismiss" `UITapGestureRecognizer`
    private var tapGestureMap = [UIView: UITapGestureRecognizer]()

    /// Map `UIView`s to their "pan to dismiss" `UIPanGestureRecognizer`
    private var panGestureMap = [UIView: UIPanGestureRecognizer]()

    /// `Order` to configure which direction the user is allowed to pan.
    ///
    /// - When `.topToBottom`, the user can pan/swipe up to dismiss
    /// - When `.bottomToTop`, the user can pan/swipe down to dismiss
    var order: Order = .topToBottom

    // MARK: - Deinit

    deinit {
        invalidate()
    }

    // MARK: - Invalidate

    /// Invalidate maps
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
    @objc
    private func viewTapped(_ sender: UITapGestureRecognizer) {
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
    @objc
    private func viewPanned(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        let state = sender.state

        // Trigger delegate callback based for `boundaryState`
        switch state.boundaryState {
        case .started:
            delegate?.postGestureManager(
                self, didStartPanGestureForView: view
            )
        case .ended:
            delegate?.postGestureManager(
                self, didEndPanGestureForView: view
            )
        default:
            break
        }

        // Handle pan based on state
        switch state {

        // Pan did update
        case .changed:
            let ty = sender.translation(in: view.superview).y
            let y = order.translationY(ty)
            view.transform = CGAffineTransform(translationX: 0, y: y)
            return

        // Pan did finish
        case .ended:
            let translateY = view.transform.ty
            if abs(translateY) > view.bounds.size.height * 0.5 {
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

// MARK: - UIGestureRecognizer.State + BoundaryState

private extension UIGestureRecognizer.State {

    /// `State` can be started or finished
    @frozen
    enum BoundaryState {

        /// `State` when the gesture started
        case started

        /// `State` when the gesture end
        case ended
    }

    /// `BoundaryState`
    var boundaryState: BoundaryState? {
        switch self {
        case .began: return .started
        case .ended, .cancelled, .failed: return .ended
        default: return nil // .possible, .changed
        }
    }
}

// MARK: - Order + Translation

private extension Order {

    func translationY(_ ty: CGFloat) -> CGFloat {
        switch self {
        case .topToBottom: return min(0, ty)
        case .bottomToTop: return max(0, ty)
        }
    }
}

//
//  ShakeView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/03/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

// MARK: - ShakeViewDelegate

/// Touch animation callbacks for `ShakeView`
public protocol ShakeViewDelegate: class {
    
    /// Invoked when the touch animation starts
    /// - Parameter shakeView: `ShakeView`
    func shakeViewAnimationDidStart(_ shakeView: ShakeView)
    
    /// Invoked when the touch animation stops
    /// - Parameters:
    ///   - shakeView: `ShakeView`
    ///   - complete: Did the animation complete
    func shakeViewAnimationDidStop(_ shakeView: ShakeView, complete: Bool)
    
    /// Pulse animation will start
    /// - Parameter shakeView: `ShakeView`
    func shakeViewPulseWillStart(_ shakeView: ShakeView)
    
    /// Pulse animation did stop
    /// - Parameter shakeView: `ShakeView`
    func shakeViewPulseDidStop(_ shakeView: ShakeView)
}

/// Implementation defaults for `ShakeViewDelegate`
public extension ShakeViewDelegate {
    
    func shakeViewAnimationDidStart(_ shakeView: ShakeView) {
        // do nothing
    }
    
    func shakeViewAnimationDidStop(_ shakeView: ShakeView, complete: Bool) {
        // do nothing
    }
    
    func shakeViewPulseWillStart(_ shakeView: ShakeView) {
        // do nothing
    }
    
    func shakeViewPulseDidStop(_ shakeView: ShakeView) {
        // do nothing
    }
}

// MARK: - ShakeView

/// A `UIView` which "shakes" in response to touch and pulses when not touching
public class ShakeView: UIView {
    
    /// Fixed constants in `ShakeView`
    private struct Constants {
        
        /// How long the user should hold their touch before the view pops/completes its animation
        static let animationDuration: TimeInterval = 2.5

        /// Occasional pulse of the view to hint that it is interactive
        static let pulseDelay: TimeInterval = 3

        /// Duration until the first pulse animation fires, from then wait`pulseDelay`
        static let firstPulseDelay: TimeInterval = 1
    }
    
    // MARK: - Properties
    
    /// `ShakeViewDelegate` for touch animation related callbacks
    public weak var delegate: ShakeViewDelegate?

    /// `CADisplayLink` to sync selector when the screen updates
    private var displayLink: CADisplayLink?
    
    /// A `Timer` which pulses this view every `pulseInterval` (except the first case)
    private var pulseTimer: Timer?
    
    /// `Date` the touch animation started
    private var animationStart: Date!
    
    /// Have we done the first pulse animation - this will determine
    /// the `pulseTimer` `TimeInterval`
    private var isFirstPulse = true
    
    /// `ShakeFunction` to handle the rotation transform of the view (on touch)
    private static let shakeFunction = ShakeFunction(
        T: Constants.animationDuration,
        Y: TimeInterval.pi / 15,
        N: 15
    )
    
    /// `ScaleFunction` to handle the scale transform of the view (on touch)
    private static let scaleFunction = ScaleFunction(
        T: Constants.animationDuration,
        Y: 1.4
    )
    
    // MARK: - Pulse Animation
    
    /// Start the pulse animation
    private func startPulse() {
        isFirstPulse = true
        startPulseTimer()
    }
    
    /// Execute pulse animation and notify delegate
    private func executePulse() {
        delegate?.shakeViewPulseWillStart(self)
        pulse { finished in
            self.delegate?.shakeViewPulseDidStop(self)
        }
    }
    
    /// Start the pulse animation timer
    private func startPulseTimer() {
        let timeInterval = isFirstPulse ?
            Constants.firstPulseDelay : Constants.pulseDelay

        pulseTimer?.invalidate()
        pulseTimer = Timer.scheduledTimer(
            withTimeInterval: timeInterval,
            repeats: true,
            block:
        { [weak self] timer in
            guard let self = self else { return }
            
            self.executePulse()
            if self.isFirstPulse {
                timer.invalidate()
                self.isFirstPulse = false
                
                self.startPulseTimer()
            }
        })
    }
    
    /// Stop the pulse animation
    private func stopPulse() {
        pulseTimer?.invalidate()
    }
    
    // MARK: - Invalidate
    
    /// Invalidate touch and pulse animations
    private func invalidate() {
        stopAnimation(complete: false)
        stopPulse() // Must be called after as the above starts the shake again!
    }
    
    // MARK: - Lifecycle
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        startPulse()
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        invalidate()
    }
    
    deinit {
        invalidate()
    }
    
    // MARK: - Touch Animation
    
    /// Start the touch animation
    private func startAnimation() {
        layer.removeAllAnimations()
        animationStart = Date()
        
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .current, forMode: .default)
        
        stopPulse()
        
        delegate?.shakeViewAnimationDidStart(self)
    }
    
    /// Stop touch animation and animate back to identity
    private func stopAnimation(complete: Bool) {
        if animationStart == nil {
            // Protecting against `touchesEnded(_:with:)` being called after explicitly
            // ending the animation (e.g. after animation ended by duration)
            return
        }
        
        layer.removeAllAnimations()
        displayLink?.invalidate()
        animationStart = nil
        
        delegate?.shakeViewAnimationDidStop(self, complete: complete)
        
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
        
        startPulse()
    }
    
    /// `CADisplayLink` step function
    @objc private func step(displaylink: CADisplayLink) {
        guard let animationStart = animationStart else {
            stopAnimation(complete: false)
            return
        }
        
        let elapsed = Date().timeIntervalSince(animationStart)
        if elapsed > Self.shakeFunction.T {
            stopAnimation(complete: true)
            return
        }
        
        let rotation = CGFloat(Self.shakeFunction.value(for: elapsed))
        let scale = CGFloat(Self.scaleFunction.value(for: elapsed))
        
        transform = CGAffineTransform.identity
            .rotated(by: rotation)
            .scaledBy(x: scale, y: scale)
    }
}

// MARK: - Touch Events

extension ShakeView {

    public override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesBegan(touches, with: event)
        startAnimation()
    }
    
    public override func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesCancelled(touches, with: event)
        stopAnimation(complete: false)
    }
    
    public override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesEnded(touches, with: event)
        stopAnimation(complete: false)
    }
    
    public override func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesMoved(touches, with: event)
    }
}

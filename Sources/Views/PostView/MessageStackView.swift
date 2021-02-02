//
//  MessageStackView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

/// A `UIStackView` with a `PostManager` for posting, queueing and removing `UIView`s
open class MessageStackView: UIStackView, Poster {

    /// How posted `UIView`s are ordered in the `arrangedSubviews`.
    public enum Order {

        /// Natural order of `UIStackView`s. Posted `UIView`s get appended to the
        /// `arrangedSubviews` array appearing below/after the previous.
        case `default` // topToBottom

        /// Reverese order of `UIStackView`s. Posted `UIView`s get inserted at the start of the
        /// `arrangedSubviews` array appearing above/before the previous.
        case reversed // bottomToTop
    }

    /// `PostManager` to manage posting, queueing, removing of `PostRequest`s
    public private(set) lazy var postManager: PostManager = {
        let postManager = PostManager(poster: self)
        postManager.isSerialQueue = false
        return postManager
    }()

    /// Default `MessageConfiguration` to apply to posted `UIView`s
    public var messageConfiguation = MessageConfiguration() {
        didSet {
            guard messageConfiguation.applyToAll else {
                return
            }

            // If the `messageConfiguation` has updated, update the current `UIView`s
            arrangedSubviewsExcludingSpace
                .compactMap { $0 as? MessageConfigurable }
                .forEach { $0.set(configuration: messageConfiguation) }
        }
    }

    /// Order of the posted `UIView`s in the `arrangedSubviews`
    ///
    /// When `.default`, `spaceView` will be the first `arrangedSubview`.
    /// When `.reversed`, `spaceView` will be the last `arrangedSubview`.
    public var order: Order = .default {
        didSet {
            updateSpaceView(updateArrangedSubviews: true)
        }
    }

    // MARK: - Views

    /// This view is for smooth animations when there are no `arrangedSubviews`
    /// in the `UIStackView`.
    /// Otherwise the `UIStackView` can not determine its width/height.
    /// With "no arranged subviews", we want to fix the width according to its constraints,
    /// but have 0 height
    public lazy var spaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    /// `NSLayoutConstraint` setting the constant of the height on the `spaceView`
    internal lazy var spaceViewHeightConstraint: NSLayoutConstraint = {
        return spaceView.heightAnchor.constraint(
            equalToConstant: .leastNormalMagnitude
        )
    }()

    /// Height of the `spaceViewHeightConstraint`.
    ///
    /// - Note:
    /// This is only **not** a computed property because the `spaceViewHeightConstraint`
    /// `.constant` may not always be equal to this value.
    /// Specifically, when the `MessageStackView` is animating the removal of it's last posted view,
    /// it will also animate the height of the `spaceView` to zero.
    public var spaceViewHeight: CGFloat = 0 {
        didSet {
            guard !arrangedSubviewsExcludingSpace.isEmpty else { return }
            spaceViewHeightConstraint.constant = spaceViewHeight
        }
    }

    // MARK: - Init

    /// Default initializer
    public convenience init() {
        self.init(arrangedSubviews: [])
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 0

        // Configure `spaceView`
        updateSpaceView(updateArrangedSubviews: true)

        // Make sure `postManger` is instantiated. This is in case `deinit` is
        // is the first instance to reference `postManager`, lazily
        // instantiating it, referencing `self`, which is being
        // de-initialized...
        _ = self.postManager.isSerialQueue
    }

    /// Invalidate on deinit
    deinit {
        postManager.invalidate()
    }

    // MARK: - ArrangedSubviews

    /// `arrangedSubviews` excluding `spaceView`
    public var arrangedSubviewsExcludingSpace: [UIView] {
        return arrangedSubviews.filter { $0 != spaceView }
    }

    // MARK: - Animation

    /// Show or hide the given `view`
    ///
    /// - Parameters:
    ///   - view: `UIView` to hide or show
    ///   - hidden: `Bool` Hide or show
    ///   - animated: `Bool` Animate setting `isHidden`
    ///   - completion: Completion block to execute
    private func setView(
        _ view: UIView,
        hidden: Bool,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        guard animated else {
            view.isHidden = hidden
            completion()
            return
        }

        let spaceViewHeightAfterAnimation = animationWillStart(hidden: hidden)
        view.isHidden = !hidden
        layoutIfNeeded()
        superview?.layoutIfNeeded()

        UIView.animate(withDuration: .animationDuration, animations: {
            view.isHidden = hidden
            self.animationWillEnd(spaceViewHeightAfterAnimation)
            self.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }

    /// Prepare `spaceView` if the animating is either:
    /// - adding the first arrangedSubview
    /// - removing the last arrangedSubview
    /// by updating its height accordingly
    ///
    /// - Parameter hidden: `Bool` Is the first/last arranged subview being hidden
    private func animationWillStart(hidden: Bool) -> CGFloat? {
        // Only 1 other arrangedSubview in addition to the space (2 overall)
        guard arrangedSubviewsExcludingSpace.count == 1 else {
            return nil
        }

        let heightAfterAnimation: CGFloat
        if hidden {
            // Removing last arrangedSubview
            heightAfterAnimation = .leastNormalMagnitude
        } else {
            // Adding first arrangedSubview
            heightAfterAnimation = spaceViewHeight

            // Don't overrite spaceViewHeight
            spaceViewHeightConstraint.constant = .leastNormalMagnitude
        }

        return heightAfterAnimation
    }

    /// If `spaceViewHeightAfterAnimation` is defined, set the `spaceViewHeight`
    /// to this.
    /// - Parameter spaceViewHeightAfterAnimation: `CGFloat?`
    private func animationWillEnd(
        _ spaceViewHeightAfterAnimation: CGFloat?
    ) {
        guard let spaceViewHeight = spaceViewHeightAfterAnimation else {
            return
        }

        // Don't overrite spaceViewHeight
        spaceViewHeightConstraint.constant = spaceViewHeight
    }

    // MARK: - SpaceView

    /// Updates the `backgroundColor` of the `spaceView` based on the "next" arranged subview.
    /// If the `spaceView` is the first in the `arrangedSubviews`, then "next" is the subview
    /// after. Otherwise "next" is the subview before.
    ///
    /// - Parameters:
    ///   - updateArrangedSubviews:
    ///       `Bool` update the position of the `spaceView` in the `arrangedSubviews` based
    ///        on the value of `spaceViewIsFirst`
    private func updateSpaceView(updateArrangedSubviews: Bool = false) {
        if updateArrangedSubviews {
            spaceView.removeFromSuperview()
            postArrangedSubview(view: spaceView, order: order.switched)
            constrainSpaceView()
        }

        let next: UIView?
        switch order {
        case .default:
            next = arrangedSubviews.elementAfterFirst(of: spaceView)
        case .reversed:
            next = arrangedSubviews.elementBeforeFirst(of: spaceView)
        }

        // Set backgroundColor equivalent to adjacent arranged subview
        spaceView.backgroundColor = next?.backgroundColor ?? .clear
    }

    /// Add `spaceView` to the `arrangedSubviews`
    private func constrainSpaceView() {
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        if !spaceViewHeightConstraint.isActive {
            spaceViewHeightConstraint.isActive = true
        }
    }

    // MARK: - Order

    /// Update `order` given `layout`
    /// - Parameter layout: `MessageLayout`
    public func updateOrderForLayout(_ layout: MessageLayout) {
        switch layout {
        case .top: order = .default
        case .bottom: order = .reversed
        }
    }

    // MARK: - Post

    /// `postArrangedSubview(view:order:)` with `view` and `order`
    ///
    /// - Parameter view: `UIView`
    private func postArrangedSubview(view: UIView) {
        postArrangedSubview(view: view, order: order)
    }

    /// Post a `view` adding it to the `arrangedSubviews`
    ///
    /// - Parameters:
    ///   - view: `UIView`
    ///   - order: `Order`
    private func postArrangedSubview(view: UIView, order: Order) {
        switch order {
        case .default:
            addArrangedSubview(view)
        case .reversed:
            insertArrangedSubview(view, at: 0)
        }
    }
}

// MARK: - UIViewPoster

extension MessageStackView: UIViewPoster {

    /// Only remove if `self` is the `view.superview`
    /// - Parameter view: `UIView`
    func shouldRemove(view: UIView) -> Bool {
        return view.superview == self
    }

    /// Post `view`
    ///
    /// - Note:
    /// This `view` will be added to a `fill` distributed `UIStackView` so its width will
    /// be determined the `UIStackView`.
    /// However its height should be determined by the `view` itself.
    /// E.g. intrinsicContentSize, autolayout, explicit height...
    ///
    /// - Parameters:
    ///   - view: `UIView` to post
    ///   - animated: `Bool` should animate post
    ///   - completion: Closure to execute on completion
    func post(
        view: UIView,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        postArrangedSubview(view: view)
        (view as? MessageConfigurable)?.set(configuration: messageConfiguation)

        // Update spaceView here too incase properties on adjacent
        // arrangedSubview has, since posting, changed
        DispatchQueue.main.async {
            self.updateSpaceView()
        }

        setView(view, hidden: false, animated: animated, completion: completion)
    }

    /// Remove posted `view`
    ///
    /// - Parameters:
    ///   - view: `UIView` to remove
    ///   - animated: `Bool` should animate remove
    ///   - completion: Closure to execute on completion
    func remove(
        view: UIView,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        setView(view, hidden: true, animated: animated) { [weak self] in
            // Apple docs say the stackView will remove it from its
            // arrangedSubviews list automatically when calling this method
            view.removeFromSuperview()
            self?.updateSpaceView()
            completion()
        }
    }
}

// MARK: - Order + Extensions

private extension MessageStackView.Order {

    /// Other `Order` (opposite direction)
    var switched: Self {
        switch self {
        case .default: return .reversed
        case .reversed: return .default
        }
    }
}

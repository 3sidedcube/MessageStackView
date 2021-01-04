//
//  ApplicationPostView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/08/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// `PostView` singleton to to be added to the `UIApplication`'s key window
class ApplicationPostView: PostView {

    /// Shared `PostView` singleton
    static let shared = ApplicationPostView()

    /// Override `removeFromSuperviewOnEmpty` forcing `true`
    override var removeFromSuperviewOnEmpty: Bool {
        get {
            return true
        }
        // swiftlint:disable unused_setter_value
        set {
        }
        // swiftlint:enable unused_setter_value
    }

    // MARK: - Init

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIWindow.didBecomeKeyNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: .viewWillAppear,
            object: nil
        )
    }

    // MARK: - Setup

    private func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidBecomeKeyNotification),
            name: UIWindow.didBecomeKeyNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewWillAppearNotification),
            name: .viewWillAppear,
            object: nil
        )
    }

    // MARK: - Functionality

    /// Add as subview to `UIApplication.shared.appKeyWindow` if required
    /// or bring to front of superview subviews hierarchy.
    ///
    /// - Parameter force:
    /// Force adding as a subview to the `UIApplication.shared.appKeyWindow` by
    /// invoking `removeFromSuperview` before
    func updateSuperviewIfRequired(force: Bool) {
        if force {
            removeFromSuperview()
        }

        guard superview == nil else {
            bringToFront()
            return
        }

        guard let keyWindow = UIApplication.shared.appKeyWindow else {
            return
        }

        addTo(
            view: keyWindow,
            layout: .top,
            constrainToSafeArea: true
        )
        keyWindow.layoutIfNeeded()
        layoutIfNeeded()
    }

    // MARK: - Notification

    @objc private func windowDidBecomeKeyNotification(
        _ sender: Notification
    ) {
        guard postManager.isActive else { return }
        updateSuperviewIfRequired(force: true)
    }

    @objc private func viewWillAppearNotification(
        _ sender: Notification
    ) {
        bringToFront()
    }

    // MARK: - PostManagerDelegate

    override func postManager(
        _ postManager: PostManager,
        willPost view: UIView
    ) {
        super.postManager(postManager, willPost: view)
        updateSuperviewIfRequired(force: false)
    }
}

//
//  HostingMessageView.swift
//  MessageStackView
//
//  Created by Szuyun Liang on 04/06/2026.
//  Copyright © 2026 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import SwiftUI
import UIKit

/// A `UIView` hosting a SwiftUI `View` so it can be posted on a `Poster`,
/// e.g. a `MessageStackView`.
///
/// - Note:
/// The view sizes itself from the SwiftUI content's intrinsic content size,
/// as required by `MessageStackView.post(view:animated:completion:)`.
public class HostingMessageView<Content: View>: UIView {

    /// `UIHostingController` owning the SwiftUI `Content`
    private let hostingController: UIHostingController<Content>

    /// The SwiftUI `Content` being hosted
    public var rootView: Content {
        get {
            return hostingController.rootView
        }
        set {
            hostingController.rootView = newValue
        }
    }

    // MARK: - Init

    /// Create hosting the given SwiftUI `View`
    /// - Parameter rootView: `Content` to host
    public init(rootView: Content) {
        hostingController = UIHostingController(rootView: rootView)
        super.init(frame: .zero)
        setup()
    }

    /// Create with coder - `NSCoder`
    /// - Warning: Unavailable, use `init(rootView:)`
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable, use init(rootView:)")
    }

    // MARK: - Setup

    /// Add the `hostingController`'s view and constrain to edges
    private func setup() {
        backgroundColor = .clear
        hostingController.view.backgroundColor = .clear
        hostingController.sizingOptions = .intrinsicContentSize
        addSubview(hostingController.view)
        hostingController.view.edgeConstraints(to: self)
    }
}

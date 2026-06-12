//
//  Poster+SwiftUI.swift
//  MessageStackView
//
//  Created by Szuyun Liang on 04/06/2026.
//  Copyright © 2026 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - PostRequest + SwiftUI

public extension PostRequest {
    /// Create a `PostRequest` wrapping a SwiftUI `View` in a `HostingMessageView`
    ///
    /// - Parameters:
    ///   - dismissAfter: `TimeInterval?`
    ///   - animated: `PostAnimation`
    ///   - content: SwiftUI `View` to post
    init<Content: View>(
        dismissAfter: TimeInterval? = .defaultDismiss,
        animated: PostAnimation = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            view: HostingMessageView(rootView: content()),
            dismissAfter: dismissAfter,
            animated: animated
        )
    }
}

// MARK: - Poster + SwiftUI

public extension Poster {
    /// Post a SwiftUI `View`, `dismissAfter`, `animated` onto the `postManager`
    ///
    /// - Parameters:
    ///   - dismissAfter: `TimeInterval?`
    ///   - animated: `PostAnimation`
    ///   - content: SwiftUI `View` to post
    ///
    /// - Returns: The `HostingMessageView` wrapping `content`, e.g. to later
    /// remove via the `postManager`
    @discardableResult
    func post<Content: View>(
        dismissAfter: TimeInterval? = .defaultDismiss,
        animated: PostAnimation = .default,
        @ViewBuilder content: () -> Content
    ) -> HostingMessageView<Content>? {
        let request = PostRequest(
            dismissAfter: dismissAfter,
            animated: animated,
            content: content
        )
        postManager.post(postRequest: request)
        return request.view as? HostingMessageView<Content>
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
#Preview {
    let viewController = UIViewController()
    viewController.view.backgroundColor = .systemBackground

    let messageStackView = MessageStackView()
    messageStackView.addTo(
        view: viewController.view,
        layout: .bottom,
        constrainToSafeArea: true
    )
    messageStackView.order = MessageLayout.bottom.toOrder()

    messageStackView.post(dismissAfter: nil) {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.white)
            Text("Login Successful")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .background(Capsule().fill(Color.green))
        .frame(maxWidth: .infinity)
        .padding(.bottom, 16)
    }

    return viewController
}

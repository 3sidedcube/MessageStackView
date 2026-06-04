//
//  Poster+SwiftUI.swift
//  MessageStackView
//
//  Created by Szuyun Liang on 04/06/2026.
//  Copyright © 2026 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - Poster + SwiftUI

public extension Poster {
    /// Post a SwiftUI `View`, `dismissAfter`, `animated` onto the `postManager`
    ///
    /// - Parameters:
    ///   - content: SwiftUI `View` to post
    ///   - dismissAfter: `TimeInterval?`
    ///   - animated: `PostAnimation`
    ///
    /// - Returns: The `HostingMessageView` wrapping `content`, e.g. to later
    /// remove via the `postManager`
    @discardableResult
    func post<Content: View>(
        _ content: Content,
        dismissAfter: TimeInterval? = .defaultDismiss,
        animated: PostAnimation = .default
    ) -> HostingMessageView<Content> {
        let view = HostingMessageView(rootView: content)
        postManager.post(postRequest: PostRequest(
            view: view,
            dismissAfter: dismissAfter,
            animated: animated
        ))
        return view
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

    messageStackView.post(
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
        .padding(.bottom, 16),
        dismissAfter: nil
    )

    return viewController
}

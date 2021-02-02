//
//  UIView+MessageStackView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView + Poster

public extension UIView {

    /// Create a `T` and constrain inline with the given arguments
    ///
    /// - Parameters:
    ///   - layout: `MessageLayout`
    ///   - constrainToSafeArea: `Bool` Contrain to the safe area
    func createPosterView<T>(
        layout: MessageLayout = .default,
        constrainToSafeArea: Bool = true
    ) -> T where T: UIView, T: Poster {
        let posterView = T()
        posterView.addTo(
            view: self,
            layout: layout,
            constrainToSafeArea: constrainToSafeArea
        )
        layoutIfNeeded()
        posterView.layoutIfNeeded()
        return posterView
    }

    // MARK: - Instance

    /// `MessageStackView` or create and constrain on `view`
    ///
    /// - Parameters:
    ///   - layout: `MessageLayout`
    ///   - constrainToSafeArea: `Bool` constrain to the safe area
    func createMessageStackView(
        layout: MessageLayout = .default,
        constrainToSafeArea: Bool = true
    ) -> MessageStackView {
        let messageStackView: MessageStackView = createPosterView(
            layout: layout,
            constrainToSafeArea: constrainToSafeArea
        )
        messageStackView.updateOrderForLayout(layout)
        return messageStackView
    }

    /// `PostView` or create and constrain on `view`
    /// - Parameters:
    ///   - layout: `MessageLayout`
    ///   - constrainToSafeArea: `Bool` constrain to the safe area
    func createPostView(
        layout: MessageLayout = .default,
        constrainToSafeArea: Bool = true
    ) -> PostView {
        return createPosterView(
            layout: layout,
            constrainToSafeArea: constrainToSafeArea
        )
    }
}

// MARK: - UIApplication + PostView

public extension UIApplication {

    /// `UIApplication` shared singleton `PostView`
    var postView: PostView {
        return ApplicationPostView.shared
    }
}

// MARK: - UIApplication + PostView

public extension MessageLayout {

    /// The default `MessageLayout`
    static let `default`: MessageLayout = .top
}

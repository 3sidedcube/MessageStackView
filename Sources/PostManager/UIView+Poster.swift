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
    ) -> T where T : UIView, T : Poster {
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
    
    /// Get the first `T` or create and add to top of `self`.
    ///
    /// - Note:
    /// This is only desired when only `MessageStackView` exists as a subview of a `UIView`.
    /// This is the common use case. But it may be practical to have one at the top and another at
    /// the bottom. In this case one must keep a reference to the `MessageStackView`s.
    ///
    /// - Parameters:
    ///   - layout: `MessageLayout`
    ///   - constrainToSafeArea: `Bool` Contrain to the safe area
    func posterViewOrCreate<T>(
        layout: MessageLayout = .default,
        constrainToSafeArea: Bool = true
    ) -> T where T : UIView, T : Poster {
        // Get first `T`
        let subview = subviews
            .compactMap { $0 as? T }
            .first
        
        // If non `nil`, return it
        if let posterView = subview {
            return posterView
        }
        
        // Otherwise create it and add to top
        return createPosterView(
            layout: layout,
            constrainToSafeArea: constrainToSafeArea
        )
    }
    
    /// `MessageStackView` or create and constrain
    /// - Parameters:
    ///   - layout: `MessageLayout`
    ///   - constrainToSafeArea: `Bool` constrain to the safe area
    func messageStackViewOrCreate(
        layout: MessageLayout = .default,
        constrainToSafeArea: Bool = true
    ) -> MessageStackView {
        let messageStackView: MessageStackView = posterViewOrCreate(
            layout: layout,
            constrainToSafeArea: constrainToSafeArea
        )
        
        messageStackView.updateOrderForLayout(layout)
        return messageStackView
    }
    
    /// `PostView` or create and constrain
    /// - Parameter layout: `MessageLayout`
    func postViewOrCreate(
        layout: MessageLayout = .default
    ) -> PostView {
        return posterViewOrCreate(layout: layout)
    }
}

// MARK: - UIViewController + MessageStackView

public extension UIViewController {
    
    /// `MessageStackView` or create and constrain on `view`
    ///
    /// - Parameters:
    ///   - layout: `MessageLayout`
    ///   - constrainToSafeArea: `Bool` constrain to the safe area
    func messageStackViewOrCreate(
        layout: MessageLayout = .default,
        constrainToSafeArea: Bool = true
    ) -> MessageStackView {
        return view.messageStackViewOrCreate(
            layout: layout,
            constrainToSafeArea: constrainToSafeArea
        )
    }
    
    /// `PostView` or create and constrain on `view`
    /// - Parameter layout: `MessageLayout`
    func postViewOrCreate(
        layout: MessageLayout = .default
    ) -> PostView {
        return view.posterViewOrCreate(layout: layout)
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

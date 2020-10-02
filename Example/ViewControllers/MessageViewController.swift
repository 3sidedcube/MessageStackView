//
//  MessageViewController.swift
//  Example
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit
import MessageStackView

class MessageViewController: UIViewController {
    
    private lazy var messageStackView: MessageStackView = {
        let messageStackView: MessageStackView = view.createMessageStackView()
        messageStackView.messageConfiguation = MessageConfiguration(
            backgroundColor: .systemGroupedBackground,
            tintColor: .gray,
            shadow: true,
            applyToAll: true
        )
        return messageStackView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Post first message
        messageStackView.post(message: Message(
            title: "This is a title",
            subtitle: "This is a subtitle, with a left image",
            leftImage: .information
        ), dismissAfter: 6)
        
        // Post another message after delay
        DispatchQueue.main.asyncAfterNow(time: .seconds(2)) { [weak self] in
            guard let self = self else { return }
            let messageView = self.messageStackView.post(
                message: Message(
                    title: "This is another title",
                    subtitle: "This is another subtitle, with a left and right image",
                    leftImage: .information,
                    rightImage: .cross
                ),
                dismissAfter: 8
            )
            
            messageView.rightImageViewSize = CGSize(width: 10, height: 10)
            self.addTapToRemoveGesture(to: messageView)
        }
        
        // Post a custom view after delay
        DispatchQueue.main.asyncAfterNow(time: .seconds(4)) { [weak self] in
            let view = CustomView()
            self?.messageStackView.post(view: view)
            self?.addTapToRemoveGesture(to: view)
        }
    }
    
    /// Add ability to remove `view` from `messageStackView` by tap
    ///
    /// - Parameter view: `UIView`
    private func addTapToRemoveGesture(to view: UIView) {
        messageStackView.postManager.gestureManager
            .addTapToRemoveGesture(to: view)
    }
}

// MARK: - CustomView

fileprivate class CustomView: UIView {
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .blue
        
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(equalToConstant: 50)
        
        // Allow the height to be defined by the stackView during animation
        heightConstraint.priority = .init(999)
        
        heightConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

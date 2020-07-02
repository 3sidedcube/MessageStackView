//
//  ViewController.swift
//  Example
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit
import MessageStackView

/// - TODO: Build an interface with buttons for users to experiment with functionality
class ViewController: UIViewController {
    
    /// `MessageManager` to control
    private lazy var messageManager: MessageManager = {
        let messageManager = MessageManager()
        messageManager.delegate = self
        return messageManager
    }()

    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageManager.addTo(.top(view))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        dispatchAfter(seconds: 2) { [weak self] in
            self?.messageManager.post(message: Message(
                title: "This is a title",
                subtitle: "This is a subtitle, with a left image",
                leftImage: .information))
        }
        
        dispatchAfter(seconds: 4) { [weak self] in
            let messageView = self?.messageManager.post(
                message: Message(
                    title: "This is another title",
                    subtitle: "And yes, this is another subtitle, but with the right image this time!",
                    leftImage: .information,
                    rightImage: .cross),
                dismiss: .after(8))
            
            messageView?.rightImageViewSize = CGSize(width: 10, height: 10)
        }
        
        dispatchAfter(seconds: 6) { [weak self] in
            self?.messageManager.post(view: CustomView(), dismiss: .onTap)
        }
    }
    
    // MARK: - Dispatch
    
    private func dispatchAfter(seconds: Int, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds), execute: closure)
    }
}

// MARK: - MessageManagerDelegate

extension ViewController : MessageManagerDelegate {
    
    func messageManager(_ messageManager: MessageManager, willRemove view: UIView) {
        print("Will remove called!")
    }
    
}

// MARK: - CustomView

fileprivate class CustomView: UIView, MessageConfigurable {
    
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
    
    func apply(configuration: MessageConfiguration) {
        print("Called")
        // do nothing
    }
}
// MARK: - Extensions

extension UIImage {
    static let information = UIImage(named: "information-32")
    static let cross = UIImage(named: "cross-32")
}

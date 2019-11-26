//
//  ViewController.swift
//  Example
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit
import MessageStackView

class ViewController: UIViewController {
    
    /// `MessageManager` to control
    private let messageManager = MessageManager()

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
                subtitle: "This is a subtitle",
                image: .information))
        }
        
        dispatchAfter(seconds: 4) { [weak self] in
            self?.messageManager.post(view: CustomView(), dismiss: .after(5))
        }
    }
    
    // MARK: - Dispatch
    
    private func dispatchAfter(seconds: Int, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds), execute: closure)
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

// MARK: - Extensions

extension UIImage {
    static let information = UIImage(named: "information-32")
}

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
class GeneralViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfterNow(time: .seconds(2)) { [weak self] in
            self?.messageStackViewOrCreate().post(message: Message(
                title: "This is a title",
                subtitle: "This is a subtitle, with a left image",
                leftImage: .information
            ), dismissAfter: 6)
        }
        
        DispatchQueue.main.asyncAfterNow(time: .seconds(4)) { [weak self] in
            let messageView = self?.messageStackViewOrCreate().post(
                message: Message(
                    title: "This is another title",
                    subtitle: "And yes, this is another subtitle, but with the right image this time!",
                    leftImage: .information,
                    rightImage: .cross
                ),
                dismissAfter: 8
            )
            
            messageView?.rightImageViewSize = CGSize(width: 10, height: 10)
        }
        
        DispatchQueue.main.asyncAfterNow(time: .seconds(6)) { [weak self] in
            let view = CustomView()
            self?.messageStackViewOrCreate().post(view: view)
            self?.messageStackViewOrCreate().postManager.gestureManager
                .addTapToRemoveGesture(to: view)
        }
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
    static let cross = UIImage(named: "cross-32")
}

//
//  WindowViewController.swift
//  Example
//
//  Created by Ben Shutt on 08/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class WindowViewController: UIViewController {
    
    /// `UIButton` top pop this `UIViewController` from `navigationController`
    /// To show posted `UIView` is on the window
    private(set) lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Pop", for: .normal)
        button.addTarget(
            self, action: #selector(buttonTouchUpInside), for: .touchUpInside
        )
        button.setTitleColor(.systemBlue, for: .normal) 
        return button
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.constrainToCenter(of: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.postViewOrCreate()?.post(badgeMessage:
            BadgeMessage(
                title: "This is a window notification",
                subtitle: "This notification has been posted on the key window",
                image: UIImage(named: "donations"),
                fillColor: .red
            )
        )
    }
    
    @objc private func buttonTouchUpInside(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIButton + CenterConstraints

extension UIView {
    
    func constrainToCenter(of view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        //sizeToFit()
    }
    
}

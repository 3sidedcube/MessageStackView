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
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        button.sizeToFit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.postViewOrCreate()?.post(badgeMessage:
            BadgeMessage(
                title: "This is a window notification",
                subtitle: "This notification has been posted on the key window",
                image: UIImage(named: "donations"),
                fillColor: .green
            )
        )
    }
    
    @objc private func buttonTouchUpInside(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

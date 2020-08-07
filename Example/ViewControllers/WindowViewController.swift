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
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // `UIButton` top pop this `UIViewController` from `navigationController`
        // To show posted `UIView` is on the window
        UIButton.addToCenter(
            of: view,
            title: "Pop",
            target: self,
            selector: #selector(popButtonTouchUpInside)
        )
        
        UIButton.addToCenter(
            of: view,
            title: "Present",
            target: self,
            selector: #selector(presentButtonTouchUpInside)
        ).transform = CGAffineTransform(translationX: 0, y: 30)
        
        UIButton.addToCenter(
            of: view,
            title: "Set Key Window",
            target: self,
            selector: #selector(keyWindowButtonTouchUpInside)
        ).transform = CGAffineTransform(translationX: 0, y: 60)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.postView.post(badgeMessage:
            BadgeMessage(
                title: "This is a window notification",
                subtitle: "This notification has been posted on the key window",
                image: UIImage(named: "donations"),
                fillColor: .red
            )
        )
    }
    
    @objc private func popButtonTouchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func presentButtonTouchUpInside(_ sender: UIButton) {
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.gray
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelBarButtonItemTouchUpInside)
        )
        
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        
        present(navigationController, animated: true)
    }
    
    @objc private func keyWindowButtonTouchUpInside(_ sender: UIButton) {
        let connectedScenes = UIApplication.shared.connectedScenes
        guard let windowScene = connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                return
        }
        
        let oldWindow = sceneDelegate.window
        let viewController = WindowRootViewController()
        
        let newWindow = UIWindow(windowScene: windowScene)
        newWindow.rootViewController = viewController
        sceneDelegate.window = newWindow
        newWindow.makeKeyAndVisible()
        
        viewController.completion = { [weak newWindow] in
            newWindow?.resignKey()
            
            sceneDelegate.window = oldWindow
            oldWindow?.makeKeyAndVisible()
        }
    }
    
    @objc private func cancelBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: - WindowRootViewController

class WindowRootViewController: UIViewController {
    
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        UIButton.addToCenter(
            of: view,
            title: "Resign Key Window",
            target: self,
            selector: #selector(buttonTouchUpInside)
        )
    }
    
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        completion?()
    }
}

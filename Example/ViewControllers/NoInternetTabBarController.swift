//
//  NoInternetTabBarController.swift
//  Example
//
//  Created by Ben Shutt on 25/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class NoInternetTabBarController: UITabBarController {

    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let icons: [UITabBarItem.SystemItem] = [
            .bookmarks,
            .contacts,
            .downloads,
            .favorites,
            .history
        ]
        
        viewControllers = icons.enumerated().map {
            UINavigationController(
                rootViewController: TabViewController(
                    item: $0.element,
                    index: $0.offset
                )
            )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ConnectivityWindowManager.shared.startObserving()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ConnectivityWindowManager.shared.stopObserving()
    }
}

// MARK: - TabViewController

class TabViewController: UIViewController {
    
    init(item: UITabBarItem.SystemItem, index: Int) {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(tabBarSystemItem: item, tag: index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        UIButton.addToCenter(
            of: view,
            title: "tableView",
            target: self,
            selector: #selector(buttonTouchUpInside)
        )
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(cancelBarButtonItemTouchUpInside)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - UIControlEvent
    
    @objc private func cancelBarButtonItemTouchUpInside(
        _ sender: UIBarButtonItem
    ){
        presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        let viewController = UITableViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
}
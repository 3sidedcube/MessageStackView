//
//  NoInternetTabBarController.swift
//  Example
//
//  Created by Ben Shutt on 25/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

class NoInternetTabBarController: UITabBarController {
    
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
            TabViewController(item: $0.element, index: $0.offset)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

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
    }
}

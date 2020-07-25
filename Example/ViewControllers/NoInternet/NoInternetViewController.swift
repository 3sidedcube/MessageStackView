//
//  NoInternetViewController.swift
//  Example
//
//  Created by Ben Shutt on 23/07/2020.
//

import Foundation
import UIKit
import MessageStackView

class NoInternetViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIButton.addToCenter(
            of: view,
            title: "tabView",
            selector: #selector(buttonTouchUpInside)
        )
    }
    
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        navigationController?.pushViewController(
            NoInternetTableViewController(),
            animated: true
        )
    }
    
}

//
//  NoInternetViewController.swift
//  Example
//
//  Created by Ben Shutt on 23/07/2020.
//

import Foundation
import UIKit
import MessageStackView

class NoInternetViewController: ConnectivityViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("tableView", for: .normal)
        button.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.constrainToCenter(of: view)
    }
    
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        navigationController?.pushViewController(
            NoInternetTableViewController(),
            animated: true
        )
    }
    
}

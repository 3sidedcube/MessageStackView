//
//  PanViewController.swift
//  Example
//
//  Created by Ben Shutt on 05/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class PanViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let messageView = messageStackViewOrCreate().post(message: Message(
            title: "Yooooo",
            subtitle: "Wassssssssssup"
        ))
        
        messageStackViewOrCreate().postManager.gestureManager
            .addPanToRemoveGesture(to: messageView)
    }
}

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
    
    private var messageStackView: MessageStackView {
        return view.messageStackViewOrCreate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messageView = messageStackView.post(message: Message(
            title: "Yooooo",
            subtitle: "Wassssssssssup"
        ))
        
        messageStackView.postManager.gestureManager
            .addPanToRemoveGesture(to: messageView)
    }
}

//
//  PanViewController.swift
//  Example
//
//  Created by Ben Shutt on 05/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class PanViewController: UIViewController {
    
    private lazy var messageStackView = view.createMessageStackView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let messageView = messageStackView.post(message: Message(
            title: "Pan me",
            subtitle: "This view can be panned in negative y translation.\nGive it a try"
        ))
        
        messageStackView.postManager.gestureManager
            .addPanToRemoveGesture(to: messageView)
    }
}

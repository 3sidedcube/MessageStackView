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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let messageView = messageStackViewOrCreate().post(message: Message(
            title: "Pan me",
            subtitle: "This view can be panned in negative y translation.\nGive it a try"
        ))
        
        messageStackViewOrCreate().postManager.gestureManager
            .addPanToRemoveGesture(to: messageView)
    }
}

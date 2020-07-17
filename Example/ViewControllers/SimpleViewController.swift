//
//  SimpleViewController.swift
//  Example
//
//  Created by Ben Shutt on 17/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class SimpleViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        postViewOrCreate().post(message: Message(
            title: "Message Title",
            subtitle: "This is message subtitle for detail",
            leftImage: .information,
            rightImage: nil
        ))
    }
}

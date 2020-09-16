//
//  UIViewController+System.swift
//  MessageStackView
//
//  Created by Ben Shutt on 16/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import AVKit
import MessageUI
import EventKitUI
import ContactsUI

extension UIViewController {
    
    /// Array of "system" `UIViewController`s.
    /// We define "system" here as an Apple `UIViewController` which mostly defines
    /// it's own UI and behaviour. It wouldn't be common to subclass
    /// (like a `UITableViewController` would)
    static var systemViewControllerTypes: [UIViewController.Type] {
        return [
            UIAlertController.self,
            SFSafariViewController.self,
            MFMailComposeViewController.self,
            MFMessageComposeViewController.self,
            UIImagePickerController.self,
            EKEventEditViewController.self,
            UIActivityViewController.self,
            CNContactViewController.self,
            UIDocumentPickerViewController.self,
            AVPlayerViewController.self
        ]
    }
    
    /// Is the `type(of: self)` in `systemViewControllerTypes`
    var isSystemViewController: Bool {
        return Self.systemViewControllerTypes.contains { type(of: self) == $0 }
    }
}

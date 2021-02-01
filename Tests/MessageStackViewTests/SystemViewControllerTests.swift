//
//  SystemViewControllerTests.swift
//  MessageStackViewTests
//
//  Created by Ben Shutt on 16/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import XCTest

import Foundation
import UIKit
import SafariServices
import AVKit
import MessageUI
import EventKitUI
import ContactsUI

@testable import MessageStackView

class SystemViewControllerTests: XCTestCase {

    func test_isSystemViewController() throws {
        XCTAssertTrue(UIAlertController().isSystemViewController)
        XCTAssertTrue(SFSafariViewController(url: .sample).isSystemViewController)
        if MFMailComposeViewController.canSendMail() {
            XCTAssertTrue(MFMailComposeViewController().isSystemViewController)
        }
        if MFMessageComposeViewController.canSendText() {
            XCTAssertTrue(MFMessageComposeViewController().isSystemViewController)
        }
        XCTAssertTrue(UIImagePickerController().isSystemViewController)
        XCTAssertTrue(EKEventEditViewController().isSystemViewController)
        XCTAssertTrue(
            UIActivityViewController(
                activityItems: [],
                applicationActivities: nil).isSystemViewController
        )
        XCTAssertTrue(CNContactViewController().isSystemViewController)
        XCTAssertTrue(
            UIDocumentPickerViewController(
                documentTypes: [".txt"], in: .open
            ).isSystemViewController
        )
        XCTAssertTrue(AVPlayerViewController().isSystemViewController)

        XCTAssertFalse(UIViewController().isSystemViewController)
        XCTAssertFalse(UITableViewController().isSystemViewController)
        XCTAssertFalse(CustomViewController().isSystemViewController)
    }
}

// MARK: - CustomViewController

class CustomViewController: UIViewController {
}

// MARK: - Extensions

private extension URL {

    /// A sample `URL`
    static let sample = URL(string: "https://3sidedcube.com/")!
}

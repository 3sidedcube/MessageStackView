//
//  NoInternetTabBarController.swift
//  Example
//
//  Created by Ben Shutt on 25/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class NoInternetTabBarController: UITabBarController {

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)

        let icons: [UITabBarItem.SystemItem] = [
            .bookmarks,
            .contacts,
            .downloads,
            .favorites
        ]

        viewControllers = icons.enumerated().map {
            UINavigationController(
                rootViewController: TabViewController(
                    item: $0.element,
                    index: $0.offset
                )
            )
        }

        viewControllers?.append(UINavigationController(
            rootViewController: TabConnectivityViewController()
        ))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let manager = ConnectivityManager.shared.messageManager
        manager.startObserving()
        manager.message.subtitle =
            "Sorry, please check your connection and try again"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        ConnectivityManager.shared.messageManager.stopObserving()
    }
}

// MARK: - TabViewController

class TabViewController: UIViewController {

    init(item: UITabBarItem.SystemItem, index: Int) {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(tabBarSystemItem: item, tag: index)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        UIButton.addToCenter(
            of: view,
            title: "tableView",
            target: self,
            selector: #selector(tableViewButtonTouchUpInside)
        )

        UIButton.addToCenter(
            of: view,
            title: "alert",
            target: self,
            selector: #selector(alertButtonTouchUpInside)
        ).transform = CGAffineTransform(translationX: 0, y: 30)

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(cancelBarButtonItemTouchUpInside)
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - UIControlEvent

    @objc
    private func cancelBarButtonItemTouchUpInside(
        _ sender: UIBarButtonItem
    ) {
        presentingViewController?.dismiss(animated: true)
    }

    @objc
    private func tableViewButtonTouchUpInside(_ sender: UIButton) {
        let viewController = UITableViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }

    @objc
    private func alertButtonTouchUpInside(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "Alert title",
            message: "Alert Message",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))

        present(alertController, animated: true)
    }
}

// MARK: - TabConnectivityViewController

class TabConnectivityViewController: ConnectivityViewController {

    /// Post a `Message` on the `messageStackView` only one, flag to determine if
    /// the message has already been posted
    private var didPostMessage = false

    /// `Timer` for posting delayed message
    weak var timer: Timer?

    /// Root `TabConnectivityViewController`.
    /// The root can push another `TabConnectivityViewController` with a different
    /// `MessageLayout`
    private var isRoot = false

    /// `MessageLayout`
    override var messageLayout: MessageLayout {
        return isRoot ? .top : .bottom
    }

    // MARK: - Init

    convenience init() {
        self.init(isRoot: true)
    }

    private init(isRoot: Bool) {
        self.isRoot = isRoot

        super.init(nibName: nil, bundle: nil)

        tabBarItem.image = .add
        tabBarItem.title = "Connect"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        guard isRoot else { return }
        UIButton.addToCenter(
            of: view,
            title: "Bottom \(MessageLayout.self)",
            target: self,
            selector: #selector(buttonTouchUpInside)
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard !didPostMessage else { return }

        let messageView = messageStackView.post(message: Message(
            title: "Hello there!",
            subtitle: "Welcome to \(Self.self)",
            leftImage: .noInternet
        ), dismissAfter: nil)
        messageView.configureNoInternet()

        messageStackView.postManager.gestureManager
            .addTapToRemoveGesture(to: messageView)

        timer = Timer.scheduledTimer(
            withTimeInterval: 3,
            repeats: false
        ) { [weak self] _ in
            self?.messageStackView.post(message: Message(
                title: "Another message",
                subtitle: "This is another message posted later"
            ))
        }

        didPostMessage = true
    }

    // MARK: - Actions

    @objc
    private func buttonTouchUpInside(_ sender: UIButton) {
        let viewController = TabConnectivityViewController(isRoot: false)
        viewController.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
}

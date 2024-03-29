//
//  RootTableViewController.swift
//  Example
//
//  Created by Ben Shutt on 05/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import UIKit

/// Element in the `UITableViewController` list
typealias ExampleElement = (
    title: String,
    type: UIViewController.Type,
    present: Bool
)

/// `UITableViewController` to choose an example `UIViewController`
class RootTableViewController: UITableViewController {

    /// `ExampleElement`
    private lazy var exampleElements: [ExampleElement] = [
        ("Window", WindowViewController.self, false),
        ("Badge Message", BadgeMessageViewController.self, false),
        ("Message", MessageViewController.self, false),
        ("No Internet", NoInternetTabBarController.self, true),
        ("Shadow", ShadowViewController.self, false),
        ("Toast", ToastViewController.self, false)
    ]

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "\(UITableViewCell.self)"
        )
        tableView.tableFooterView = UIView()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return 1
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return exampleElements.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(UITableViewCell.self)",
            for: indexPath
        )

        cell.textLabel?.font = UIFont.systemFont(
            ofSize: 22,
            weight: .semibold
        )
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = element(at: indexPath).title
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let element = self.element(at: indexPath)

        let viewController = element.type.init()
        viewController.view.backgroundColor = .white

        if element.present {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        } else {
            navigationController?.pushViewController(
                viewController,
                animated: true
            )
        }
    }

    // MARK: - Element

    /// `ExampleElement` at `indexPath`
    /// - Parameter indexPath: `IndexPath`
    private func element(at indexPath: IndexPath) -> ExampleElement {
        return exampleElements[indexPath.row]
    }
}

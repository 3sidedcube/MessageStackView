//
//  NoInternetViewController.swift
//  Example
//
//  Created by Ben Shutt on 23/07/2020.
//

import Foundation
import UIKit
import MessageStackView

class NoInternetViewController: UIViewController {
    
    private var messageStackView: MessageStackView {
        return messageStackViewOrCreate(layout: .bottom, constrainToSafeArea: false)
    }
    
    private var observer: NSObjectProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observer = ConnectivityManager.shared.addObserver { [unowned self] state in
            if case .notConnected = state {
                self.onNoInternet()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let observer = observer {
            ConnectivityManager.shared.removeObserver(observer)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func onNoInternet() {
        messageStackView.spaceViewHeight = view.safeAreaInsets.bottom
        let messageView = messageStackView.post(message: Message(
            title: "No Internet Connection",
            subtitle: "Please check your connection and try again",
            leftImage: .noInternet
        ))
        messageView.configureNoInternet()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        messageStackView.spaceViewHeight = view.safeAreaInsets.bottom
    }
}


private extension UILabel {
    
    func configure(ofSize size: CGFloat, weight: UIFont.Weight) {
        textColor = .white
        font = UIFont.systemFont(ofSize: size, weight: weight)
    }
}

private extension MessageView {
    
    func configureNoInternet() {
        backgroundColor = .darkGray
        leftImageViewSize = leftImageView.image?.size ?? .zero
        titleLabel.configure(ofSize: 15, weight: .semibold)
        subtitleLabel.configure(ofSize: 13, weight: .regular)
        shadowComponents = nil
    }
}

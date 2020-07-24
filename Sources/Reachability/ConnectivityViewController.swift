//
//  ConnectivityViewController.swift
//  MessageStackView
//
//  Created by Ben Shutt on 24/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

open class ConnectivityViewController: UIViewController {
    
    /// `MessageLayout` to define contraint behavior of `messageStackView`
    open var messageLayout: MessageLayout {
        return .bottom
    }
    
    /// `MessageStackView` at the bottom of the screen
    public private(set) lazy var messageStackView: MessageStackView = {
        let messageStackView: MessageStackView = view.createPosterView(
            layout: messageLayout,
            constrainToSafeArea: false
        )
        messageStackView.updateOrderForLayout(messageLayout)
        return messageStackView
    }()
    
    /// Observer for internect connectivity `Notification`s
    private var observer: NSObjectProtocol?
    
    // MARK: - ViewController lifecycle
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observer = ConnectivityManager.shared.addObserver { [weak self] state in
            if case .notConnected = state {
                self?.postNoInternetMessage()
            } else {
                self?.removeNoInternetMessage()
            }
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let observer = observer {
            ConnectivityManager.shared.removeObserver(observer)
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        didUpdateSafeArea()
    }
    
    // MARK: - SafeArea
    
    private func didUpdateSafeArea() {
        messageStackView.spaceViewHeight = safeAreaInset
    }
    
    /// Safe area inset of `view`
    private var safeAreaInset: CGFloat {
        switch messageLayout {
        case .top: return view.safeAreaInsets.top
        case .bottom: return view.safeAreaInsets.bottom
        }
    }
    
    // MARK: - Messages
    
    /// Post the "No Internet Connection" `Message`
    private func postNoInternetMessage() {
        didUpdateSafeArea() // Update before post
        
        let messageView = messageStackView.post(message: Message(
            title: "No Internet Connection",
            subtitle: "Please check your connection and try again",
            leftImage: .noInternet
        ))
        messageView.configureNoInternet()
    }
    
    /// Remove the "No Internet Connection" `Message`
    private func removeNoInternetMessage() {
        messageStackView.postManager.removeCurrent()
    }
}

// MARK: - MessageView + Configure

private extension MessageView {
    
    /// Configure UI properties for the no internet `MessageView`
    func configureNoInternet() {
        backgroundColor = .darkGray
        leftImageViewSize = leftImageView.image?.size ?? .zero
        titleLabel.configure(ofSize: 15, weight: .semibold)
        subtitleLabel.configure(ofSize: 13, weight: .regular)
        shadowComponents = nil
    }
}

// MARK: - UILabel + Configure

private extension UILabel {
    
    /// Configure UI properties for the no internet `UILabel`
    /// - Parameters:
    ///   - size: `CGFloat` Size of the font
    ///   - weight: `UIFont.Weight` of the font
    func configure(ofSize size: CGFloat, weight: UIFont.Weight) {
        textColor = .white
        font = UIFont.systemFont(ofSize: size, weight: weight)
    }
}

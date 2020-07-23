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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        messageStackView.messageConfiguation = MessageConfiguration(
            backgroundColor: .darkGray
        )
        
        let messageView = messageStackView.post(message: Message(
            title: "No Internet Connection",
            subtitle: "Please check your connection and try again",
            leftImage: .noInternet
        ))
        
        messageView.leftImageViewSize = CGSize(width: 28, height: 28)
        messageView.titleLabel.configure(ofSize: 15, weight: .semibold)
        messageView.subtitleLabel.configure(ofSize: 13, weight: .regular)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        messageStackView.spaceViewHeight = view.safeAreaInsets.bottom
    }
    
}


private extension UILabel {
    
    func configure(ofSize size: CGFloat, weight: UIFont.Weight) {
        textColor = .white
        font = UIFont.systemFont(ofSize: size, weight: weight)
    }
}

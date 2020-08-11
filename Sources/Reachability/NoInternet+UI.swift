//
//  NoInternet+UI.swift
//  MessageStackView
//
//  Created by Ben Shutt on 24/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MessageView + Configure

public extension MessageView {
    
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

extension UILabel {
    
    /// Configure UI properties for the no internet `UILabel`
    /// - Parameters:
    ///   - size: `CGFloat` Size of the font
    ///   - weight: `UIFont.Weight` of the font
    func configure(ofSize size: CGFloat, weight: UIFont.Weight) {
        textColor = .white
        font = UIFont.systemFont(ofSize: size, weight: weight)
    }
}

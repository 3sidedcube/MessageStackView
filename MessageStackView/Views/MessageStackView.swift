//
//  MessageStackView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

/// Simply a `UIStackView`, defined for type restriction
open class MessageStackView: UIStackView
{
    /// This view is for smooth animations when there are no `arrangedSubviews` in the `UIStackView`.
    /// Otherwise the `UIStackView` can not determine it's width/height.
    /// With "no arranged subviews", we want to fix the width according to it's constraints,
    /// but have 0 height
    public lazy var spaceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 0)
        ])
        return view
    }()
    
    /// Default init
    public convenience init() {
        self.init(arrangedSubviews: [])
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 0
        
        addArrangedSubview(spaceView)
    }
    
    /// `arrangedSubviews` excluding `spaceView`
    public var arrangedSubviewsExcludingSpace: [UIView] {
        return arrangedSubviews.filter { $0 !== spaceView }
    }
}

//
//  ShadowViewController.swift
//  Example
//
//  Created by Ben Shutt on 02/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class ShadowViewController: UIViewController {
    
    /// `UIStackView` container of views
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        stackView.spacing = 0
        
        return stackView
    }()
    
    /// Recommended `ShadowView` approach
    private(set) lazy var view1: UIView = {
        let view1 = ShadowView()
        view1.backgroundColor = .green
        
        // NeuomorphicShadow can be done before `viewDidlayoutSubviews()`
        // and setting corners
        view1.setNeuomorphicShadow()
        setupCorners(view1)
        return view1
    }()
    
    /// Non `ShadowView` with `createSubview` as `true`
    private(set) lazy var view2: UIView = {
        let view2 = UIView()
        view2.backgroundColor = .gray
        setupCorners(view2)
        
        // NeuomorphicShadow can be done before `viewDidlayoutSubviews()`
        // but not setting corners
        view2.setNeuomorphicShadow(createSubview: true)
        return view2
    }()
    
    /// Non `ShadowView` with `createSubview` as `false`
    private(set) lazy var view3: UIView = {
        let view3 = UIView()
        view3.backgroundColor = .purple
        setupCorners(view3)
        
        // NeuomorphicShadow xan not be done before `viewDidlayoutSubviews()`
        // or setting corners
        return view3
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        constrain()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ensure `viewDidLayoutSubviews` updates with latest subview frames?
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // We need `view3`'s frame to have updated here
        view3.setNeuomorphicShadow(createSubview: false)
    }
    
    // MARK: - Subviews
    
    private func setupCorners(_ view: UIView) {
        view.layer.cornerRadius = 10
        if #available(iOS 13, *) {
            view.layer.cornerCurve = .continuous
        }
    }
    
    private func addSubviews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(SampleView(
            view: view1, text: "\(ShadowView.self)"
        ))
        stackView.addArrangedSubview(SampleView(
            view: view2, text: "\(UIView.self) neuomorphic w/ subview"
        ))
        stackView.addArrangedSubview(SampleView(
            view: view3, text: "\(UIView.self) neuomorphic w/o subview"
        ))
    }
    
    private func constrain() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 10
            ),
            stackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 10
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -10
            )
        ])
    }
}

// MARK: - SampleView

private class SampleView: UIView {
    
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        
        return stackView
    }()
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    init (view: UIView, text: String) {
        super.init(frame: .zero)
        setup(withView: view, text: text)
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(withView view: UIView, text: String) {
        addSubview(stackView)
        stackView.addArrangedSubview(view)
        stackView.addArrangedSubview(label)
        
        label.text = text
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            view.widthAnchor.constraint(equalToConstant: 80),
            view.heightAnchor.constraint(equalTo: view.widthAnchor),
            
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
}

//
//  NeuomorphicShadow.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/09/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// Neuomorphic shadow styling to add to a `CALayer`
public enum NeuomorphicShadow {
    
    /// Neuomorphic shadow centralised on view
    case center
    
    /// Neuomorphic shadow dropped below view
    case dropped
}

// MARK: - NeuomorphicShadow + ShadowComponents

public extension NeuomorphicShadow {
    
    /// `ShadowComponents`s for the given `NeuomorphicShadow`
    var components: [ShadowComponents] {
        switch self {
        case .center: return [
            .init(
                radius: 2,
                opacity: 0.05,
                color: .shadowGray,
                offset: .init(width: 0, height: 1)
            ),
            .init(
                radius: 2,
                opacity: 0.03,
                color: .shadowGray,
                offset: .init(width: 0, height: -1)
            ),
            .init(
                radius: 8,
                opacity: 0.05,
                color: .shadowGray,
                offset: .init(width: 0, height: 2)
            )
        ]
            
        case .dropped: return [
            .init(
                radius: 2,
                opacity: 0.14,
                color: .neomorphicGray1, offset: .zero
            ),
            .init(
                radius: 9,
                opacity: 0.2,
                color: .neomorphicGray2,
                offset: .init(width: 0, height: 6)
            )
        ]
        }
    }
}

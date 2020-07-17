//
//  String+Extensions.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

extension String {
    
    /// Shorthand to trim `.whitespacesAndNewlines` characters in a `String`
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

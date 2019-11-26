//
//  String+Extensions.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

extension String {
    
    /// Shorthand to trim whitespaces and newLine characters in a `String`
    var trim: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

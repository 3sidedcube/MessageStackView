//
//  MessageStackView+Remove.swift
//  MessageStackView
//
//  Created by Ben Shutt on 03/07/2020.
//  Copyright © 2020 Ben Shutt. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Remove

extension MessageStackView {
    
    /// Remove a `MessageView`.
    /// Checks if the `messageView` superview is the `messageStackView`, if not,
    /// does nothing and simply returns
    ///
    /// - Parameters:
    ///     - messageView: `UIView` to remove
    ///     - animated: Whether to animate the removal of the `messageView`
    ///
    /// - Returns: The `MessageView` created and added to the `messageStackView`
    public func remove(view: UIView, animated: Bool = true) {
        timerMap[view]?.invalidate()
        timerMap[view] = nil
        
        removeTapGesture(from: view)
        
        guard view.superview == self else {
            return
        }
        
        // Fire will remove
        self.delegate?.messageStackView(self, willRemove: view)
        
        guard animated else {
            view.removeFromSuperview()
            
            // Fire did remove
            self.delegate?.messageStackView(self, didRemove: view)
            
            return
        }
        
        layoutIfNeeded()
        UIView.animate(withDuration: .animationDuration, animations: {
            view.isHidden = true
            self.layoutIfNeeded()
        }) { finished in
            // Apple docs say the stackView will remove it from its arrangedSubviews list automatically
            // when calling this method
            view.removeFromSuperview()
            
            // Fire did remove
            self.delegate?.messageStackView(self, didRemove: view)
        }
    }
    
}

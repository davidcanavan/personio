//
//  UIView+.swift
//  Personio
//
//  Created by David Canavan on 02/07/2021.
//

import UIKit

public extension UIView {
    
    func fillToSuperviewMargins() {
        
        guard let superviewMarginsGuide = self.superview?.layoutMarginsGuide else {
            return
        }
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superviewMarginsGuide.leadingAnchor),
            self.topAnchor.constraint(equalTo: superviewMarginsGuide.topAnchor),
            self.trailingAnchor.constraint(equalTo: superviewMarginsGuide.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superviewMarginsGuide.bottomAnchor)
        ])
    }
    
    func centerInSuperView() {
        
        guard let superview = self.superview else {
            return
        }
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
}

//
//  UIView+.swift
//  Personio
//
//  Created by David Canavan on 02/07/2021.
//

import UIKit

/// Conventience extensions to UIView to handle layouts
public extension UIView {
    
    /// Default time interval used in the app for animations
    static var defaultAnimationDuration: TimeInterval = 0.4
    
    /// Fills the given view to its superview
    /// - Parameter margins: Option to constrain to margins or not
    func fillToSuperview(margins: Bool) {
        
        let superviewLayoutGuideOrNil = margins ? self.superview?.layoutMarginsGuide : self.superview?.safeAreaLayoutGuide
        
        guard let superviewLayoutGuide = superviewLayoutGuideOrNil else {
            return
        }
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superviewLayoutGuide.leadingAnchor),
            self.topAnchor.constraint(equalTo: superviewLayoutGuide.topAnchor),
            self.trailingAnchor.constraint(equalTo: superviewLayoutGuide.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superviewLayoutGuide.bottomAnchor)
        ])
    }
    
    /// Centers the given view in it's superview
    func centerInSuperView(multiplier: CGFloat = 0.8) {
        
        guard let superview = self.superview else {
            return
        }
        
        let centerx = self.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        let centery = self.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        centery.priority = .required
        
        NSLayoutConstraint.activate([centerx, centery])
    }
    
}

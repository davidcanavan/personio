//
//  UIScrollView+.swift
//  Personio
//
//  Created by David Canavan on 17/07/2021.
//

import UIKit

public extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

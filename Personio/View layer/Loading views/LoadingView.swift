//
//  LoadingView.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import UIKit

/// UIView that shows a loading indicator
public class LoadingView: UIView {
    
    // MARK: - Initialisers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Not implemented, use init with frame instead")
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.loadView()
    }
    
    // MARK: - User interface
    
    public lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        return loadingIndicator
    }()
    
    // MARK: - Lifecycle
    
    /// Handles UI, layout and bindings
    public func loadView() {
        self.addSubview(self.loadingIndicator)
        self.loadingIndicator.centerInSuperView()
    }
}

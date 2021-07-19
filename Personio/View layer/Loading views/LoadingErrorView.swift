//
//  LoadingErrorView.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import UIKit

/// UIView that gives the user the option to retry given they've encountered an error
public class LoadingErrorView: UIView {
    
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
    
    /// The main text to show the user
    public lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "We encountered an unexpected error"
        textLabel.accessibilityIdentifier = "loading.loading_error_view.text_label"
        return textLabel
    }()
    
    /// The retry button
    public lazy var actionButton: UIButton = {
        let actionButton = UIButton(type: .roundedRect)
        actionButton.backgroundColor = .systemBlue
        actionButton.tintColor = .white
        actionButton.layer.cornerRadius = 4
        actionButton.setTitle("Try again", for: .normal)
        actionButton.accessibilityIdentifier = "loading.loading_error_view.action_button"
        return actionButton
    }()
    
    /// Stackview for layout
    public lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.textLabel, self.actionButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    /// Handles UI, layout and bindings
    public func loadView() {
        self.addSubview(self.contentStackView)
        self.contentStackView.centerInSuperView(multiplier: 10)
    }
}

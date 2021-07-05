//
//  LoadingErrorView.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import UIKit

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
    
    public lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "We encountered an unexpected error"
        return textLabel
    }()
    
    public lazy var actionButton: UIButton = {
        let actionButton = UIButton(type: .roundedRect)
        actionButton.backgroundColor = .systemBlue
        actionButton.tintColor = .white
        actionButton.layer.cornerRadius = 4
        actionButton.setTitle("Try again", for: .normal)
        return actionButton
    }()
    
    public lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.textLabel, self.actionButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    public func loadView() {
        self.addSubview(self.contentStackView)
        self.contentStackView.centerInSuperView()
    }
}

//
//  LoadingView.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

public class LoadingView: UIView {
    
    // MARK: - Internal vars
    internal var viewModel: LoadingViewModel!
    internal let disposeBag = DisposeBag()
    
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
        loadingIndicator.startAnimating()
        return loadingIndicator
    }()
    
    public lazy var loadingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
//        self.viewModel.loadingText.bind(to: label.rx.text).disposed(by: self.disposeBag)
        return label
    }()
    
    public lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loadingIndicator, loadingTextLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    public func loadView() {
        self.addSubview(self.contentStackView)
        self.contentStackView.fillToSuperviewMargins()
    }
}

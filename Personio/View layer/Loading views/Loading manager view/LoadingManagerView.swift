//
//  LoadingManagerView.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

public class LoadingManagerView: UIView {
    
    // MARK: - Internal vars
    internal let disposeBag = DisposeBag()
    internal var viewModel: LoadingManagerViewModel!
    internal var loadedView: UIView!
    
    // MARK: - Initialisers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Not implemented, use init with frame instead")
    }
    
    convenience init(viewModel: LoadingManagerViewModel, loadedView: UIView) {
        self.init(frame: CGRect.zero)
        self.viewModel = viewModel
        self.loadedView = loadedView
        self.loadingView = loadingView
        self.loadingErrorView = loadingErrorView
        self.loadView()
    }
    
    // MARK: - User interface
    
    public lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    public lazy var loadingErrorView: LoadingErrorView = {
        let loadingErrorView = LoadingErrorView()
        loadingErrorView.translatesAutoresizingMaskIntoConstraints = false
        loadingErrorView.actionButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance) // Stop rage taps
            .bind(to: self.viewModel.reloadRequested)
            .disposed(by: self.disposeBag)
        return loadingErrorView
    }()
    
    // MARK: - Lifecycle
    
    public func loadView() {
        
        self.viewModel.loadingStatus.bind { [weak self] (loadingStatus) in
            switch loadingStatus {
            case .loaded:
                self?.handleLoadedStatus()
            case .loading:
                self?.handleLoadingStatus()
            case .loadingError(let error):
                self?.handleErrorStatus(error: error)
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    internal func removeAllSubviews(except exceptionView: UIView) {
        let filteredSubviews = self.subviews.filter({ $0 != exceptionView })
        UIView.animate(withDuration: UIView.defaultAnimationDuration, animations: {
            filteredSubviews.forEach({ $0.alpha = 0 })
        }, completion: { (completed) in
            filteredSubviews.forEach({ $0.removeFromSuperview() })
        })
    }
    
    internal func addAndFillSubviewAnimated(_ subview: UIView) {
        subview.alpha = 0
        self.addSubview(subview)
        subview.fillToSuperviewMargins()
        UIView.animate(withDuration: UIView.defaultAnimationDuration, animations: {
            subview.alpha = 1
        })
    }
    
    internal func handleLoadingStatus() {
        self.addAndFillSubviewAnimated(self.loadingView)
        self.removeAllSubviews(except: self.loadingView)
    }
    
    internal func handleErrorStatus(error: Error) {
        self.addAndFillSubviewAnimated(self.loadingErrorView)
        self.removeAllSubviews(except: self.loadingErrorView)
        print(error)
    }
    
    internal func handleLoadedStatus() {
        self.addAndFillSubviewAnimated(self.loadedView)
        self.removeAllSubviews(except: self.loadedView)
    }
}

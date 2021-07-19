//
//  LoadingManagerView.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

/// Generic view that handles loading UI based on the values in the `LoadingStatus` enum
public class LoadingManagerView: UIView {
    
    // MARK: - Internal vars
    
    /// Dispose bag for Rx subsriptions
    internal let disposeBag = DisposeBag()
    
    /// View model
    internal var viewModel: LoadingManagerViewModel!
    
    /// View to show when the component state has changed to `.loaded`
    internal var loadedView: UIView!
    
    // MARK: - Initialisers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Not implemented, use init with frame instead")
    }
    
    /// Creates a new `LoadingManagerView`
    /// - Parameters:
    ///   - viewModel: The view model that drives the underlying view
    ///   - loadedView: View to show when the component state has changed to `.loaded`
    convenience init(viewModel: LoadingManagerViewModel, loadedView: UIView) {
        self.init(frame: CGRect.zero)
        self.viewModel = viewModel
        self.loadedView = loadedView
        self.loadingView = loadingView
        self.loadingErrorView = loadingErrorView
        self.loadView()
    }
    
    // MARK: - User interface
    
    /// View to display when loading
    public lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.accessibilityIdentifier = "loading.loading_view"
        loadingView.loadingIndicator.accessibilityIdentifier = "loading.loading_view.indicator"
        return loadingView
    }()
    
    /// View to display when an error has been encountered
    public lazy var loadingErrorView: LoadingErrorView = {
        let loadingErrorView = LoadingErrorView()
        loadingErrorView.translatesAutoresizingMaskIntoConstraints = false
        loadingErrorView.accessibilityIdentifier = "loading.loading_error_view"
        loadingErrorView.actionButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance) // Stop rage taps
            .bind(to: self.viewModel.reloadRequested)
            .disposed(by: self.disposeBag)
        return loadingErrorView
    }()
    
    // MARK: - Lifecycle
    
    /// Handles UI, layout and bindings
    public func loadView() {
        
        self.viewModel.loadingStatus.drive { [weak self] (loadingStatus) in
            switch loadingStatus {
            case .loaded:
                self?.handleLoadedStatus()
            case .loading:
                self?.handleLoadingStatus()
            case .loadingError(let error):
                self?.handleErrorStatus(error: error)
            case .pending:
                break
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    /// Removes all subviews from the `LoadingManagerView` but ignores the specified one
    /// View removals are animated
    internal func removeAllSubviews(except exceptionView: UIView) {
        let filteredSubviews = self.subviews.filter({ $0 != exceptionView })
        UIView.animate(withDuration: UIView.defaultAnimationDuration, animations: {
            filteredSubviews.forEach({ $0.alpha = 0 })
        }, completion: { (completed) in
            filteredSubviews.forEach({ $0.removeFromSuperview() })
        })
    }
    
    /// Adds a subview and fits it to the `LoadingManagerView` margins with animation
    internal func addAndFillSubviewAnimated(_ subview: UIView) {
        subview.alpha = 0
        self.addSubview(subview)
        subview.fillToSuperview(margins: true)
        UIView.animate(withDuration: UIView.defaultAnimationDuration, animations: {
            subview.alpha = 1
        })
    }
    
    /// Updates the view given that we've recieved a `.loading` status
    internal func handleLoadingStatus() {
        self.addAndFillSubviewAnimated(self.loadingView)
        self.removeAllSubviews(except: self.loadingView)
    }
    
    /// Updates the view given that we've recieved a `.loadingError` status
    internal func handleErrorStatus(error: Error) {
        self.addAndFillSubviewAnimated(self.loadingErrorView)
        self.removeAllSubviews(except: self.loadingErrorView)
    }
    
    /// Updates the view given that we've recieved a `.loaded` status
    internal func handleLoadedStatus() {
        self.addAndFillSubviewAnimated(self.loadedView)
        self.removeAllSubviews(except: self.loadedView)
    }
}

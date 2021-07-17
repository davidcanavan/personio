//
//  LoadingManagerViewModel.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

public protocol LoadingManagerViewModel {
    
    // MARK: - Inputs
    var loadingStatus: Driver<LoadingStatus> { get }
    
    // MARK: - Outputs
    var reloadRequested: PublishRelay<Void> { get }
}

public class DefaultLoadingManagerViewModel: LoadingManagerViewModel {
    
    // MARK: - Inputs
    public var loadingStatus: Driver<LoadingStatus>
    
    // MARK: - Outputs
    public var reloadRequested: PublishRelay<Void> = PublishRelay()
    
    public init(loadingStatus: Driver<LoadingStatus>) {
        self.loadingStatus = loadingStatus
    }
}

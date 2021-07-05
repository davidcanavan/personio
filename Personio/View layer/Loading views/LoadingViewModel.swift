//
//  LoadingViewModel.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

public protocol LoadingViewModel {
    var loadingStatus: PublishRelay<LoadingStatus> {get}
    var loadingText: PublishRelay<String> {get}
}

public class DefaultLoadingViewModel: LoadingViewModel {
    
    public var loadingStatus: PublishRelay<LoadingStatus> = PublishRelay()
    public var loadingText: PublishRelay<String> = PublishRelay()
    
}

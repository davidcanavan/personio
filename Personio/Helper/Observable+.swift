//
//  Observable+.swift
//  Personio
//
//  Created by David Canavan on 16/07/2021.
//

import Foundation
import RxSwift

public extension RxSwift.ObservableType {
    
    func getLoadingStatusStream() -> Observable<LoadingStatus> {
        return Observable<LoadingStatus>.merge([
            Observable.just(.loading),
            self.materialize()
                .filter({ $0.element == nil }) // Filter out next()'s
                .map { (event) -> LoadingStatus in
                    switch event {
                    case let .error(error):
                        return .loadingError(error: error)
                    default:
                        return .loaded
                    }
                }
        ])
    }
}

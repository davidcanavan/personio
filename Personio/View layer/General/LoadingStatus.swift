//
//  ViewLoadingStatus.swift
//  Personio
//
//  Created by David Canavan on 04/07/2021.
//

import Foundation

/// Generic model enum that handles any component's loading state
public enum LoadingStatus: Equatable {
    case pending
    case loading
    case loaded
    case loadingError(error: Error)
    
    // MARK: - Equatable
    
    /// Note: used for testing
    public static func == (lhs: LoadingStatus, rhs: LoadingStatus) -> Bool {
        
        switch (lhs, rhs) {
        case ( .loadingError(_), .loadingError(_) ):
            return true
        case ( .loading, .loading ), ( .loaded, .loaded ):
            return true
        default:
            return false
        }
    }
}

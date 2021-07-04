//
//  ViewLoadingStatus.swift
//  Personio
//
//  Created by David Canavan on 04/07/2021.
//

import Foundation

public enum LoadingStatus {
    case loading
    case loaded
    case error(error: Error)
}

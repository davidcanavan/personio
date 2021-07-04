//
//  PersonioServiceManager.swift
//  Personio
//
//  Created by David Canavan on 04/07/2021.
//

import Foundation

/// Factory methods for Personio services
public enum PersonioServiceFactory {
    
    /// Factory instance of the `RemoteNetworkService`
    public static var remoteNetworkService = {
        LiveRemoteNetworkService()
    }()
    
    /// Factory instance of the `PersonioRemoteService`
    public static var personioRemoteService = {
        return LivePersonioRemoteService(with: Self.remoteNetworkService)
    }()
    
}

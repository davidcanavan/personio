//
//  PersonioServiceManager.swift
//  Personio
//
//  Created by David Canavan on 04/07/2021.
//

import Foundation

/// General purpose error for mocking purposes
public enum MockError: Error {
    case mock
}

/// Factory methods for Personio services
public enum PersonioServiceFactory {
    
    /// Factory instance of the `RemoteNetworkService`
    public static var remoteNetworkService: RemoteNetworkService = {
        return LiveRemoteNetworkService()
    }()
    
    /// Factory instance of the `PersonioRemoteService`
    public static var personioRemoteService: PersonioRemoteService = {
        
        // Create some mocks for testing
        let mockResponses = [
            MockServerResponse(
                delay: 1,
                error: MockError.mock,
                jsonURL: nil
            ),
            MockServerResponse(
                delay: 1,
                error: nil,
                jsonURL: URL(fileURLWithPath: Bundle.main.path(forResource: "candidates", ofType: "json")!)
            )
        ]

        let mockService = MockPersonioRemoteService(mockServerResponses: mockResponses)
        return mockService
        
//        return LivePersonioRemoteService(with: Self.remoteNetworkService)
    }()
    
}

//
//  PersonioRemoteService.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation
import RxSwift

/// Holder data structure for URL constants
public enum PersonioRemoteServiceSupportedURLs {
    public static let candidates: String = "http://personio-fe-test.herokuapp.com/api/v1/candidates"
}

/// Generic interface definition for remote call to personio APIs
public protocol PersonioRemoteService {
    /// Returns the list of candidates from the candidate endpoint
    func getCandidateList(page: Int) -> Observable<PagedResponse<Candidate>>
}

/// Default implementation of the personio service, as opposed to mocks used for testing
public class LivePersonioRemoteService: PersonioRemoteService {

    /// The network service we'll use to make remote calls
    internal let remoteNetworkService: RemoteNetworkService
    
    /// Creates a new `LivePersonioRemoteService`
    /// - Parameter remoteService: The unuderlying network service we'll use to make remote calls
    public init(with remoteService: RemoteNetworkService) {
        self.remoteNetworkService = remoteService
    }
    
    // MARK: - PersonioRemoteService implementation
    
    /// Returns the list of candidates from the candidate endpoint
    /// - Returns: The candidate list
    public func getCandidateList(page: Int) -> Observable<PagedResponse<Candidate>> {
        return self.remoteNetworkService
            .request(.get, PersonioRemoteServiceSupportedURLs.candidates)
    }
}


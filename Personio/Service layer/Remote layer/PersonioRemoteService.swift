//
//  PersonioRemoteService.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation
import RxSwift
import RxAlamofire

/// Holder data structure for URL constants
public enum PersonioRemoteServiceSupportedURLs {
    public static let candidates: String = "http://personio-fe-test.herokuapp.com/api/v1/candidates"
}

/// Generic interface definition for remote call to personio APIs
public protocol PersonioRemoteService {
    /// Returns the list of candidates from the candidate endpoint
    func getCandidateList() -> Observable<[Candidate]>
}

/// Default implementation of the personio service, as opposed to mocks used for testing
//public class DefaultPersonioRemoteService: PersonioRemoteService {
//
//    /// Returns the list of candidates from the candidate endpoint
//    /// - Returns: The candidate list
//    public func getCandidateList() -> Observable<[Candidate]> {
//        RxAlamofire.json(.get, PersonioRemoteServiceSupportedURLs.candidates)
//    }
//
//
//}


//
//  MockResponse.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import Foundation
import RxSwift

/// General purpose object to handle mock server responses for testing
public class MockServerResponse {
    
    /// How long we want to wait for this request to return in seconds
    public let delay: Int
    /// The error we want to forward to the observers
    public let error: Error?
    /// The json we want to forward to the observers
    public let jsonURL: URL?
    
    
    /// Creates a new `MockServerResponse`
    /// - Parameters:
    ///   - waitingPeriod: How long we want to wait for this request to return in seconds
    ///   - error: The error we want to forward to the observers
    ///   - jsonURL: The json we want to forward to the observers
    public init(delay: Int, error: Error?, jsonURL: URL?) {
        self.delay = delay
        self.error = error
        self.jsonURL = jsonURL
    }
}

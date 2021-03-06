//
//  MockPersonioRemoteService.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation
import RxSwift

/// Conventience implementation of the remote service that accepts and array of mocks
public class MockPersonioRemoteService: PersonioRemoteService {
    
    /// Mock responses to loop through
    internal var mockServerResponses: [MockServerResponse]
    /// Current position in the mock response array
    internal var currentMockServerResponsePosition: Int
    
    /// Creates a new `MockPersonioRemoteService`
    /// - Parameter mockServerResponses: The list of mocks we want to return
    init(mockServerResponses: [MockServerResponse]) {
        self.mockServerResponses = mockServerResponses
        self.currentMockServerResponsePosition = 0
    }
    
    // MARK: - PersonioRemoteService implementation
    
    /// Returns the list of candidates from the candidate endpoint
    /// - Returns: The candidate list
    public func getCandidateList(page: Int) -> Observable<PagedResponse<Candidate>> {
        
        // Get the mock response
        let maxIndex = min(self.currentMockServerResponsePosition, self.mockServerResponses.count - 1)
        let mockResponse = self.mockServerResponses[maxIndex]
        self.currentMockServerResponsePosition += 1
        
        // If it's an error we need to create a new observable since errors terminate immediately
        if let error = mockResponse.error {
            if mockResponse.delay == 0 {
                return Observable.error(error)
            }
            return Observable.create { (observer) -> Disposable in
                Thread.sleep(forTimeInterval: TimeInterval(mockResponse.delay))
                observer.onError(error)
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
        }
        // Otherwise load the object from json
        else if let jsonURL = mockResponse.jsonURL {
            let candidates: [Candidate] = self.loadArrayFromJSON(at: jsonURL)
            let pageSize = 20
            let pageCount = candidates.count == 0 ? 0 : (candidates.count - 1) / pageSize + 1
            let pagedResponse = PagedResponse<Candidate>(
                page: page,
                items:
                    Array(candidates[
                            page*pageSize..<min((page + 1)*pageSize, candidates.count)
                    ]
                ),
                hasMore: page >= pageCount)
            
            if mockResponse.delay == 0 {
                return Observable.just(pagedResponse)
            }
            return Observable.just(pagedResponse)
                .delay(.seconds(mockResponse.delay), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
        }
        
        // Crash the mock if the user didn't add any mock data
        fatalError("No mock error or json provided")
    }
    
    internal func loadObjectFromJSON<T: Decodable>(at url: URL) -> T {
        let data = try! Data(contentsOf: url)
        let decodedObject = try! JSONDecoder().decode(T.self, from: data)
        return decodedObject
    }
    
    internal func loadArrayFromJSON<T: Decodable>(at url: URL) -> [T] {
        let data = try! Data(contentsOf: url)
        let decodedObject = try! JSONDecoder().decode([T].self, from: data)
        return decodedObject
    }
}

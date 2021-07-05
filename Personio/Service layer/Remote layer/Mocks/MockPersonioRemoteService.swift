//
//  MockPersonioRemoteService.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation
import RxSwift

public class MockPersonioRemoteService: PersonioRemoteService {
    
    internal var mockServerResponses: [MockServerResponse]
    internal var currentMockServerResponsePosition: Int
    
    init(mockServerResponses: [MockServerResponse]) {
        self.mockServerResponses = mockServerResponses
        self.currentMockServerResponsePosition = 0
    }
    
    public func getCandidateList() -> Observable<[Candidate]> {
        
        // Get the mock response
        let mockResponse = self.mockServerResponses[self.currentMockServerResponsePosition]
        self.currentMockServerResponsePosition += 1
        
        if let error = mockResponse.error {
            if mockResponse.delay == 0 {
                return Observable.error(error)
            }
            return Observable.create { (observer) -> Disposable in
                Thread.sleep(forTimeInterval: TimeInterval(mockResponse.delay))
                observer.onError(error)
                return Disposables.create()
            }
            .subscribe(on: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.instance)
        }
        else if let jsonURL = mockResponse.jsonURL {
            let listResponse: GenericListResponse<Candidate> = self.loadObjectFromJSON(from: jsonURL)
            
            if mockResponse.delay == 0 {
                return Observable.just(listResponse.data)
            }
            return Observable.just(listResponse.data)
                .delay(.seconds(mockResponse.delay), scheduler: MainScheduler.asyncInstance)
        }
        
        fatalError("No mock error or json provided")
    }
    
    internal func loadObjectFromJSON<T: Decodable>(from url: URL) -> T {
        let data = try! Data(contentsOf: url)
        let decodedObject = try! JSONDecoder().decode(T.self, from: data)
        return decodedObject
    }
    
}

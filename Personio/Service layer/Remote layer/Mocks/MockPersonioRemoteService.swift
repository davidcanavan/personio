//
//  MockPersonioRemoteService.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation
import RxSwift

public class MockPersonioRemoteService: PersonioRemoteService {
    
    public func getCandidateList() -> Observable<[Candidate]> {
        
        guard let path = Bundle.main.path(forResource: "candidates", ofType: "json") else {
            return Observable.empty()
        }
        
        let url = URL(fileURLWithPath: path)
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Data cannot be found at the file url, please check your test data.")
        }
        
        do {
            let candidateListResponse = try JSONDecoder().decode(GenericListResponse<Candidate>.self, from: data)
            return Observable.just(candidateListResponse.data)
        } catch (let error) {
            return Observable.error(error)
        }
    }
    
    
}

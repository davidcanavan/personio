//
//  PersonioTests.swift
//  PersonioTests
//
//  Created by David Canavan on 01/07/2021.
//

import XCTest
import RxSwift
@testable import Personio

class PersonioTests: XCTestCase {
    
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        self.disposeBag = nil
    }

    func test_candidateModelParsingSuccess() throws {
//        let candidates: [Candidate] = [
//            
//        ]
//        
//        MockPersonioRemoteService()
//            .getCandidateList()
//            .subscribe(onNext: { candidates in
//                XCTAssert(self.can)
//                self?.candidates = candidates
//                self?.tableView.reloadData()
//            }, onError: { error in
//                XCTFail("Unexpected error")
//            } ).disposed(by: self.disposeBag)
//        
//        
//        let mockRemoteService = 
    }

}

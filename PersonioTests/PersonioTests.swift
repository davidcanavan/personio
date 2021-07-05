//
//  PersonioTests.swift
//  PersonioTests
//
//  Created by David Canavan on 01/07/2021.
//

import XCTest
import RxSwift
@testable import Personio

class CandaidateListViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        self.disposeBag = nil
    }

    func test_candidateListViewModel_looadingSuccess() throws {
        let mockResponses = []
        
        
    }
    
    
    func test_candidateListViewModel_looadingError() throws {
    }

}

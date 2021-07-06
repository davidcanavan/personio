//
//  PersonioTests.swift
//  PersonioTests
//
//  Created by David Canavan on 01/07/2021.
//

import XCTest
import RxSwift
@testable import Personio

class CandidateListViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        self.disposeBag = nil
    }

    /// Unit test for loading success case
    func test_loadingSuccess() throws {
        let loadingStatusExpectation = self.expectation(description: "Loading status check")
        let candidatesExpectation = self.expectation(description: "Candidates count check")
        
        defer {
            XCTWaiter().wait(for: [loadingStatusExpectation, candidatesExpectation], timeout: 0.2)
        }
        
        // Create the mocks
        let mockResponses = [
            MockServerResponse(delay: 0, error: nil, jsonURL: self.getJSONFileURLInTestBundle(forResource: "candidates_case_success"))
        ]
        let mockService = MockPersonioRemoteService(mockServerResponses: mockResponses)
        let viewModel = DefaultCandidateListViewModel(personioRemoteService: mockService)
        
        // Mock the call and get the values
        // Check that we're getting only 2 loading enum values .loading and .loaded
        viewModel.loadingStatus
            .buffer(timeSpan: .milliseconds(100), count: 10, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { (loadingStatuses) in
                XCTAssertEqual(loadingStatuses.count, 2)
                XCTAssertEqual(loadingStatuses[0], LoadingStatus.loading)
                XCTAssertEqual(loadingStatuses[1], LoadingStatus.loaded)
                loadingStatusExpectation.fulfill()
            }).disposed(by: disposeBag)
        // Check that we're getting the correct candidates back and only once
        viewModel.candidateViewModels
            .buffer(timeSpan: .milliseconds(100), count: 10, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { (nestedViewModelArray) in
                XCTAssertEqual(nestedViewModelArray.count, 1)
                let url = self.getJSONFileURLInTestBundle(forResource: "candidates_case_success")
                let comparison: GenericListResponse<Candidate> = self.loadObjectFromJSON(from: url)
                let candidates: [Candidate] = nestedViewModelArray.first!.map({
                    let cellViewModel = $0 as! CandidateGeneralCellViewModel
                    return cellViewModel.candidate
                })
                XCTAssertEqual(candidates, comparison.data)
                candidatesExpectation.fulfill()
        }).disposed(by: disposeBag)
        viewModel.loadData()
    }
    
    
    /// Unit test for loading error case
    func test_loadingError() throws {
        let loadingStatusExpectation = self.expectation(description: "Loading status check")
        let candidatesExpectation = self.expectation(description: "Candidates count check")
        
        defer {
            XCTWaiter().wait(for: [loadingStatusExpectation, candidatesExpectation], timeout: 0.2)
        }
        
        // Create the mocks
        let mockResponses = [
            MockServerResponse(delay: 0, error: MockError.mock, jsonURL: nil)
        ]
        let mockService = MockPersonioRemoteService(mockServerResponses: mockResponses)
        let viewModel = DefaultCandidateListViewModel(personioRemoteService: mockService)
        
        // Mock the call and get the values
        // Check that we're getting only 2 loading enum values .loading and .loadingError
        viewModel.loadingStatus
            .buffer(timeSpan: .milliseconds(100), count: 10, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { (loadingStatuses) in
                XCTAssertEqual(loadingStatuses.count, 2)
                XCTAssertEqual(loadingStatuses[0], LoadingStatus.loading)
                XCTAssertEqual(loadingStatuses[1], LoadingStatus.loadingError(error: MockError.mock))
                loadingStatusExpectation.fulfill()
        }).disposed(by: disposeBag)
        // Check that we're getting the correct candidates back and only once
        viewModel.candidateViewModels
            .buffer(timeSpan: .milliseconds(100), count: 10, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { (nestedViewModelArray) in
                XCTAssertEqual(nestedViewModelArray.count, 0)
                candidatesExpectation.fulfill()
        }).disposed(by: disposeBag)
        viewModel.loadData()
    }
    
    /// Helper function to get the test bundle
    internal var testBundle: Bundle {
        return Bundle(for: CandidateListViewModelTests.self)
    }
    
    internal func getJSONFileURLInTestBundle(forResource resource: String) -> URL {
        let path = self.testBundle.path(forResource: resource, ofType: "json")!
        return URL(fileURLWithPath: path)
    }
    
    /// Helper function to load some objects from json
    internal func loadObjectFromJSON<T: Decodable>(from url: URL) -> T {
        let data = try! Data(contentsOf: url)
        let decodedObject = try! JSONDecoder().decode(T.self, from: data)
        return decodedObject
    }

}

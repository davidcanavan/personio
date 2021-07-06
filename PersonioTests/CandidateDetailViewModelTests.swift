//
//  CandidateDetailViewModelTests.swift
//  PersonioTests
//
//  Created by David Canavan on 06/07/2021.
//

import XCTest
import RxSwift
@testable import Personio

class CandidateDetailViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        self.disposeBag = nil
    }

    /// Unit test for loading data correctly
    func test_loadData() throws {
        
        let expectation = self.expectation(description: "Expecting sections")
        
        defer {
            self.wait(for: [expectation], timeout: 0.2)
        }
        
        // Get the test data
        let url = self.getJSONFileURLInTestBundle(forResource: "candidates_case_success")
        let apiResponse: GenericListResponse<Candidate> = self.loadObjectFromJSON(from: url)
        let candidate = apiResponse.data.first!
        
        // Mock the call and get the values
        let viewModel = DefaultCandidateDetailViewModel(candidate: candidate)
        
        // Check that we're getting the correct candidate sections back and only once
        viewModel.sectionViewModels
            .buffer(timeSpan: .milliseconds(100), count: 10, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { (nestedSectionsArray) in
                XCTAssertEqual(nestedSectionsArray.count, 1)
                let sections = nestedSectionsArray.first!
                let applicationItems = sections[0].items
                let candidateDetailItems = sections[1].items
                
                XCTAssertEqual(applicationItems[0].subtitle, candidate.positionApplied)
                XCTAssertEqual(applicationItems[1].subtitle, candidate.applicationDate)
                XCTAssertEqual(applicationItems[2].subtitle, String(candidate.yearsOfExperience))
                XCTAssertEqual(applicationItems[3].subtitle, candidate.status)
                
                XCTAssertEqual(candidateDetailItems[0].subtitle, candidate.email)
                XCTAssertEqual(candidateDetailItems[1].subtitle, candidate.birthDate)
                XCTAssertEqual(candidateDetailItems[2].subtitle, String(23))
                
                expectation.fulfill()
        }).disposed(by: disposeBag)
        viewModel.loadData()
    }
    
    func test_ageCalculation() throws {
        
        // Get the test data
        let url = self.getJSONFileURLInTestBundle(forResource: "candidates_case_success")
        let apiResponse: GenericListResponse<Candidate> = self.loadObjectFromJSON(from: url)
        let candidate = apiResponse.data.first!
        
        // Mock the call and get the values
        let viewModel = DefaultCandidateDetailViewModel(candidate: candidate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nowDate = dateFormatter.date(from: "2021-07-06")!
        // Current date
        XCTAssertEqual(viewModel.calculateAge(from: "2021-07-06", at: nowDate), 0)
        // Future dates
        XCTAssertEqual(viewModel.calculateAge(from: "2021-07-07", at: nowDate), nil)
        XCTAssertEqual(viewModel.calculateAge(from: "2023-07-05", at: nowDate), nil)
        // Past dates
        XCTAssertEqual(viewModel.calculateAge(from: "2021-07-05", at: nowDate), 0)
        XCTAssertEqual(viewModel.calculateAge(from: "2020-07-07", at: nowDate), 0)
        XCTAssertEqual(viewModel.calculateAge(from: "2020-07-05", at: nowDate), 1)
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


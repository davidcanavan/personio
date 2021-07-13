//
//  PersonioUITests.swift
//  PersonioUITests
//
//  Created by David Canavan on 01/07/2021.
//

import XCTest

class PersonioUITests: XCTestCase {
    
    internal var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        self.app = XCUIApplication()
        self.app.launchArguments.append("--uitesting")

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_fullApp() throws {
        app.launch()
        
        // Check that we're showing a loading
        XCTAssert(app.otherElements["loading.loading_view"].firstMatch.exists)
//        XCTAssert(app.otherElements["loading.loading_view.indicator"].firstMatch.exists)
        
        // Check that we're showing the retry screen
        let loadingErrorView = app.otherElements["loading.loading_error_view"]
        XCTAssert(loadingErrorView.waitForExistence(timeout: 1.1))
        let actionButton = loadingErrorView.buttons["loading.loading_error_view.action_button"]
        XCTAssert(actionButton.isHittable && actionButton.isEnabled)
        actionButton.tap()
        XCTAssert(!actionButton.isHittable)
        
        // Check we're showing the main content
        let table = app.tables["candidate_list.list"]
        XCTAssert(table.waitForExistence(timeout: 1.1))
        
        // Check the detail and navigate back
        table.cells.firstMatch.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

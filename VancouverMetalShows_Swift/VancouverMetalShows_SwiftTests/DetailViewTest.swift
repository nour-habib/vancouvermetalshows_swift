//
//  DetailViewTest.swift
//  VancouverMetalShows_SwiftTests
//
//  Created by Nour Habib on 2023-11-12.
//

import XCTest
@testable import VancouverMetalShows_Swift

class DetailViewTest: XCTestCase {
    
    private var detailView: DetailView!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let show = Show("5", "Metallica", "2025-01-02","Rogers Arena", "", "$100", "", "0")
        detailView = DetailView(frame: .zero, show: show)

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        detailView = nil
        
        
        super.tearDown()
    }

    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_showView()
    {
        //XCTAssertNotNil(detailView.show)
    }

}

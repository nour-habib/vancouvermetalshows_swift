//
//  ShowsTableViewTest.swift
//  VancouverMetalShows_SwiftTests
//
//  Created by Nour Habib on 2023-11-10.
//

import XCTest
@testable import VancouverMetalShows_Swift


class ShowsTableViewTest: XCTestCase {
    
    private var delegateDataSource: TableViewDataSourceDelegate!
    private var tableView: ShowsTableView!
    private var data = [Show(), Show(), Show(), Show(), Show()]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        tableView = ShowsTableView()
     
        delegateDataSource = TableViewDataSourceDelegate(shows: data)
        tableView.delegate = delegateDataSource
        tableView.dataSource =  delegateDataSource
        
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        tableView = nil
        delegateDataSource = nil
        
        super.tearDown()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_numberOfRows()
    {
        XCTAssertEqual(delegateDataSource.tableView(tableView, numberOfRowsInSection: 0), 5)
    }

}

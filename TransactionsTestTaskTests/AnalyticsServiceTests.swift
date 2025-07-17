//
//  AnalyticsServiceTests.swift
//  TransactionsTestTaskTests
//
//  Created by Andrii Kravtsov on 16.07.2025.
//

import XCTest
@testable import TransactionsTestTask

final class AnalyticsServiceTests: XCTestCase {
    
    var service: AnalyticsService!
    
    override func setUp() {
        super.setUp()
        service = AnalyticsServiceImpl()
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    func testTrackEventStoresEvent() {
        service.trackEvent(name: "screen_open", parameters: ["screen": "wallet"])
        
        let events = service.getEvents(name: nil, from: nil, to: nil)
        
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.name, "screen_open")
        XCTAssertEqual(events.first?.parameters["screen"], "wallet")
    }
    
    func testFilterByName() {
        service.trackEvent(name: "event1", parameters: [:])
        service.trackEvent(name: "event2", parameters: [:])
        
        let result = service.getEvents(name: "event2", from: nil, to: nil)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "event2")
    }

    func testFilterByDateRange() {
        let now = Date()
        let past = now.addingTimeInterval(-3600)
        let future = now.addingTimeInterval(3600)

        service.trackEvent(name: "rate_update", parameters: [:])

        let result = service.getEvents(name: nil, from: past, to: future)

        print("Results: \(result)")
        
        XCTAssertEqual(result.count, 1)
    }

    func testFilterByDateOutsideRange() {
        let past = Date.now.addingTimeInterval(-3600)

        service.trackEvent(name: "rate_update", parameters: [:])

        let result = service.getEvents(name: nil, from: nil, to: past)
        XCTAssertEqual(result.count, 0)
    }

    func testCombinedFilters() {
        let now = Date()
        let future = now.addingTimeInterval(3600)

        service.trackEvent(name: "A", parameters: [:])
        service.trackEvent(name: "B", parameters: [:])

        let result = service.getEvents(name: "B", from: now.addingTimeInterval(-1), to: future)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "B")
    }
}

//
//  BitcoinRateServiceTests.swift
//  TransactionsTestTaskTests
//
//  Created by Andrii Kravtsov on 16.07.2025.
//

import XCTest
import Combine
@testable import TransactionsTestTask

final class BitcoinRateServiceTests: XCTestCase {
    
    private var provider: MockBitcoinRateProvider!
    private var repository: MockBitcoinRateRepository!
    private var service: BitcoinRateService!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        provider = MockBitcoinRateProvider()
        repository = MockBitcoinRateRepository(rate: nil)
    }

    override func tearDown() {
        service = nil
        provider = nil
        repository = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testLoadsCachedRateOnInit() {
        repository.save(65000)
        provider.result = .failure(MockError.fake)

        service = BitcoinRateServiceImpl(provider: provider, repository: repository)

        XCTAssertEqual(service.rate, 65000)
    }

    func testPublishesNewRateOnSuccessfulFetch() async {
        let response = BitcoinRateResponse(amount: "72000", base: "some", currency: "some")
        provider.result = .success(response)

        let expectation = XCTestExpectation(description: "Wait for rate update")
        var receivedRates: [Double] = []

        service = BitcoinRateServiceImpl(provider: provider, repository: repository)

        service.ratePublisher
            .sink { value in
                receivedRates.append(value)
                if value == 72000 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s

        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedRates.last, 72000)
        XCTAssertEqual(repository.load(), 72000)
    }

    func testInvalidResponseAmountDoesNotCrashOrSave() async {
        let response = BitcoinRateResponse(amount: "invalid", base: "some", currency: "some")
        provider.result = .success(response)

        service = BitcoinRateServiceImpl(provider: provider, repository: repository)

        try? await Task.sleep(nanoseconds: 300_000_000)

        XCTAssertEqual(service.rate, 0)
        XCTAssertTrue(repository.load() == nil)
    }

    func testFetchFailureDoesNotCrash() async {
        provider.result = .failure(MockError.fake)
        service = BitcoinRateServiceImpl(provider: provider, repository: repository)

        try? await Task.sleep(nanoseconds: 300_000_000)

        XCTAssertEqual(service.rate, 0)
        XCTAssertTrue(repository.load() == nil)
    }

    enum MockError: Error {
        case fake
    }
}

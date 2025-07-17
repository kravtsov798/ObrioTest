//
//  WalletBalanceServiceTests.swift
//  TransactionsTestTaskTests
//
//  Created by Andrii Kravtsov on 16.07.2025.
//

import XCTest
import Combine
@testable import TransactionsTestTask

final class WalletBalanceServiceTests: XCTestCase {

    private var repository: MockWalletBalanceRepository!
    private var service: WalletBalanceService!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        repository = MockWalletBalanceRepository(initialBalance: 50.0)
        service = WalletBalanceServiceImpl(repository: repository)
    }

    override func tearDown() {
        service = nil
        repository = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testInitialBalanceIsLoadedFromRepository() {
        XCTAssertEqual(service.balance, 50.0)
    }

    func testAddFundsIncreasesBalance() {
        service.add(funds: 25)
        XCTAssertEqual(service.balance, 75.0)
        XCTAssertEqual(repository.load(), 75.0)
    }

    func testWithdrawFundsDecreasesBalance() {
        service.withdraw(funds: 20)
        XCTAssertEqual(service.balance, 30.0)
        XCTAssertEqual(repository.load(), 30.0)
    }

    func testCanWithdrawReturnsTrueWhenEnoughFunds() {
        XCTAssertTrue(service.canWithdraw(funds: 40))
    }

    func testCanWithdrawReturnsFalseWhenInsufficientFunds() {
        XCTAssertFalse(service.canWithdraw(funds: 100))
    }

    func testBalancePublisherEmitsValues() {
        let expectation = XCTestExpectation(description: "Should emit new balance")

        var publishedValues: [Double] = []

        service.balancePublisher
            .dropFirst()
            .sink { value in
                publishedValues.append(value)
                if publishedValues.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        service.add(funds: 10)      // 60
        service.withdraw(funds: 20) // 40

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(publishedValues, [60.0, 40.0])
    }
}

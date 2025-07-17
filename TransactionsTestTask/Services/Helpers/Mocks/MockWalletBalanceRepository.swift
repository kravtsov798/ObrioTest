//
//  MockWalletBalanceRepository.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 16.07.2025.
//


final class MockWalletBalanceRepository: WalletBalanceRepository {
    var balance: Double?
    
    init(initialBalance: Double?) {
        balance = initialBalance
    }

    func save(_ balance: Double) {
        self.balance = balance
    }

    func load() -> Double? {
        return balance
    }
}

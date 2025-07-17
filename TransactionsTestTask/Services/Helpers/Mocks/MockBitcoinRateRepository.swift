//
//  MockBitcoinRateRepository.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 16.07.2025.
//


final class MockBitcoinRateRepository: BitcoinRateRepository {
    private var cachedRate: Double?
    
    init(rate: Double?) {
        cachedRate = rate
    }

    func save(_ rate: Double) {
        cachedRate = rate
    }

    func load() -> Double? {
        cachedRate
    }
}

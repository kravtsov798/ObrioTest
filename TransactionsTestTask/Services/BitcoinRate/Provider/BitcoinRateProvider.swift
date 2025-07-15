//
//  BitcoinPriceProvider.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import Foundation

protocol BitcoinRateProvider {
    func getRate() async throws -> BitcoinRateResponse
}

final class BitcoinRateProviderImpl: NetworkService, BitcoinRateProvider {
    func getRate() async throws -> BitcoinRateResponse {
        let endpoint = GetBitcoinRate()
        return try await request(with: endpoint)
    }
}

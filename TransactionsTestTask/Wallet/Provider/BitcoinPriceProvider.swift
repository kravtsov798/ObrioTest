//
//  BitcoinPriceProvider.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import Foundation

protocol BitcoinPriceProvider {
    func getPrice() async throws -> BitcoinPriceResponse
}

final class BitcoinPriceProviderImpl: NetworkService, BitcoinPriceProvider {
    func getPrice() async throws -> BitcoinPriceResponse {
        let endpoint = GetBitcoinPrice()
        return try await request(with: endpoint)
    }
}

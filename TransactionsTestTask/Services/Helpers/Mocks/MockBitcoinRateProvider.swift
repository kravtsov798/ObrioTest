//
//  MockBitcoinRateProvider.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 16.07.2025.
//

final class MockBitcoinRateProvider: BitcoinRateProvider {
    var result: Result<BitcoinRateResponse, Error>!

    func getRate() async throws -> BitcoinRateResponse {
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        case .none: fatalError("Result must be set")
        }
    }
}

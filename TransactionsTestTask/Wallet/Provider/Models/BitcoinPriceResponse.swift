//
//  BitcoinPriceResponse.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import Foundation

struct BitcoinPriceResponse: Decodable {
    var amount: String
    var base: String
    var currency: String
}

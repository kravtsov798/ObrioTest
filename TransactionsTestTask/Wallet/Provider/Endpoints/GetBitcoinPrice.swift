//
//  GetBitcoinPrice.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import Foundation

struct GetBitcoinPrice: Endpoint {
    var method: HTTPMethod = .GET
    var url: URL? = URL(string: "https://api.coinbase.com/v2/prices/spot?currency=USD")
}

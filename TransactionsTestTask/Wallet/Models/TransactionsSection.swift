//
//  TransactionsSection.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import Foundation

struct TransactionsSection {
    var title: String
    var items: [Transaction]
    
    static let mocked: [TransactionsSection] = [
        .init(title: "Today", items: [
            .init(type: .deposit, time: "11:05", amount: 0.001),
            .init(type: .expense(category: .electronics), time: "12.56", amount: 0.0123),
            .init(type: .expense(category: .restaurant), time: "12.56", amount: 0.0123)
        ]),
        .init(title: "Yesterday", items: [
            .init(type: .expense(category: .other), time: "01.12", amount: 1.25),
            .init(type: .expense(category: .restaurant), time: "12.56", amount: 0.0123)
        ])
    ]
}

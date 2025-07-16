//
//  TransactionModel.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 16.07.2025.
//

import Foundation

struct TransactionModel {
    var id: UUID
    var date: Date
    var type: TransactionType
    var category: TransactionExpenseCategory?
    var amount: Double
}

extension TransactionModel {
    init?(entity: TransactionEntity) {
        guard let transactionType = TransactionType(rawValue: entity.type) else { return nil }
        let expenseCategory = TransactionExpenseCategory(rawValue: entity.category ?? "")
        
        id = entity.id
        date = entity.date
        type = transactionType
        category = expenseCategory
        amount = entity.amount
    }
}

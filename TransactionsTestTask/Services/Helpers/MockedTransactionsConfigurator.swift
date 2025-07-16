//
//  MockedTransactionsConfigurator.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//

import Foundation

class MockedTransactionsConfigurator {
    static func addDummyTransactions() {
        for _ in (0...10) {
            addDummyTransaction()
        }
    }
    
    static func addDummyTransaction() {
        let context = CoreDataStack.shared.context
        let entity = TransactionEntity(context: context)
        let type = TransactionType.allCases.randomElement()!
        let category = TransactionExpenseCategory.allCases.randomElement()!
        
        entity.id = UUID()
        entity.date = Date().addingTimeInterval(Double.random(in: -86400*10...0))
        entity.type = type.rawValue
        entity.category = type == .expense ? category.rawValue : nil
        entity.amount = Double.random(in: 5...100)
        
        try? context.save()
    }
}

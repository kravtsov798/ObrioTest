//
//  TransactionExpenseCategory.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//

import Foundation

enum TransactionExpenseCategory: String, CaseIterable {
    case taxi
    case groceries
    case electronics
    case restaurant
    case other
    
    var title: String {
        self.rawValue.capitalized
    }
}

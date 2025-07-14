//
//  TransactionType.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import UIKit

enum TransactionType: Equatable {
    case deposit
    case expense(category: TransactionExpenseCategory)
    
    var title: String {
        return switch self {
        case .expense(let category):
            category.rawValue
        case .deposit:
            "Deposit"
        }
    }
    
    var image: UIImage? {
        UIImage(systemName: "plus")
    }
}

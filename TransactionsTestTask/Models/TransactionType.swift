//
//  TransactionType.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//

import UIKit

enum TransactionType: String, CaseIterable {
    case income
    case expense
    
    var image: UIImage? {
        return switch self {
        case .income: UIImage(systemName: "arrow.up.circle")
        case .expense: UIImage(systemName: "arrow.down.circle")
        }
    }
    
    var title: String {
        return switch self {
        case .income: "Income"
        case .expense: "Expense"
        }
    }
    
    var accentColor: UIColor {
        return switch self {
        case .income: .systemGreen
        case .expense: .systemRed.withAlphaComponent(0.8)
        }
    }
}

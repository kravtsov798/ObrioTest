//
//  TransactionMapper.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//

import UIKit

final class TransactionMapper {
    static func mapEntityToUIModel(_ entity: TransactionEntity) -> TransactionUIModel? {
        guard let type = TransactionType(rawValue: entity.type) else { return nil }
        let category = TransactionExpenseCategory(rawValue: entity.category ?? "")
        
        let title: String = type == .income
        ? type.title
        : category?.title ?? "Expense"
        
        var amount = entity.amount.formattedCurrencyString() ?? ""
        amount.insert(type == .income ? "+" : "-", at: amount.startIndex)
        
        let uiModel = TransactionUIModel(
            image: type.image,
            title: title,
            time: entity.date.formattedTimeString(),
            amount: amount,
            accentColor: type.accentColor
        )
        return uiModel
    }
}

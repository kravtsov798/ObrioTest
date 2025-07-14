//
//  Transaction.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import UIKit

struct Transaction {
    var type: TransactionType
    var title: String { type.title }
    var image: UIImage? { type.image }
    var time: String
    var amount: Double
}

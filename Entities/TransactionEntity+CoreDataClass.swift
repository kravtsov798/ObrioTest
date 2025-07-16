//
//  TransactionEntity+CoreDataClass.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//
//

public import Foundation
public import CoreData

public typealias TransactionEntityCoreDataClassSet = NSSet

@objc(TransactionEntity)
public class TransactionEntity: NSManagedObject {
    func update(with model: TransactionModel) {
        self.id = model.id
        self.date = model.date
        self.type = model.type.rawValue
        self.category = model.category?.rawValue
        self.amount = model.amount
    }
}

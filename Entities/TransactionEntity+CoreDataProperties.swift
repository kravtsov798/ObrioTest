//
//  TransactionEntity+CoreDataProperties.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//
//

public import Foundation
public import CoreData


public typealias TransactionEntityCoreDataPropertiesSet = NSSet

extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]
        return request
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var amount: Double
    @NSManaged public var type: String
    @NSManaged public var category: String?

}

extension TransactionEntity : Identifiable {
    @objc var sectionDate: String {
        self.date.formattedDateString()
    }
}

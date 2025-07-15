//
//  BitcoinRateEntity+CoreDataProperties.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//
//

public import Foundation
public import CoreData


public typealias BitcoinRateEntityCoreDataPropertiesSet = NSSet

extension BitcoinRateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BitcoinRateEntity> {
        return NSFetchRequest<BitcoinRateEntity>(entityName: "BitcoinRateEntity")
    }

    @NSManaged public var rate: Double
    @NSManaged public var timestamp: Date?

}

extension BitcoinRateEntity : Identifiable {

}

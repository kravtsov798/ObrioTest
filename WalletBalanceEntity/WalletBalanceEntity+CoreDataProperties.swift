//
//  WalletBalanceEntity+CoreDataProperties.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//
//

public import Foundation
public import CoreData


public typealias WalletBalanceEntityCoreDataPropertiesSet = NSSet

extension WalletBalanceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletBalanceEntity> {
        return NSFetchRequest<WalletBalanceEntity>(entityName: "WalletBalanceEntity")
    }

    @NSManaged public var balance: Double

}

extension WalletBalanceEntity : Identifiable {

}

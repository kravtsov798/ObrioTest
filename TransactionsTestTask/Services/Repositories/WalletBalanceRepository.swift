//
//  WalletBalanceRepository.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//

import CoreData
import Foundation

protocol WalletBalanceRepository {
    func save(_ balance: Double)
    func load() -> Double?
}

final class WalletBalanceRepositoryImpl: WalletBalanceRepository {
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save(_ balance: Double) {
        deleteOld()
        
        let entity = WalletBalanceEntity(context: context)
        entity.balance = balance
        
        try? context.save()
    }
    
    func load() -> Double? {
        let request = WalletBalanceEntity.fetchRequest()
        request.fetchLimit = 1
        return try? context.fetch(request).first?.balance
    }
    
    private func deleteOld() {
        let request = WalletBalanceEntity.fetchRequest()
        
        guard let entities = try? context.fetch(request) else { return }
        entities.forEach { context.delete($0) }
    }
}

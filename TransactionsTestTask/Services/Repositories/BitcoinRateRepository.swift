//
//  BitcoinRateRepository.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//

import CoreData

protocol BitcoinRateRepository {
    func save(_ rate: Double)
    func load() -> Double?
}

final class BitcoinRateRepositoryImpl: BitcoinRateRepository {
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save(_ rate: Double) {
        deleteOld()
        
        let entity = BitcoinRateEntity(context: context)
        entity.timestamp = Date.now
        entity.rate = rate
        
        try? context.save()
    }
    
    func load() -> Double? {
        let request = BitcoinRateEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = 1
        
        return try? context.fetch(request).first?.rate
    }
    
    private func deleteOld() {
        let request = BitcoinRateEntity.fetchRequest()
        
        guard let entities = try? context.fetch(request) else { return }
        entities.forEach {
            context.delete($0)
        }
    }
}

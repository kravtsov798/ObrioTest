//
//  TransactionRepository.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//

import CoreData

protocol TransactionRepository {
    func save(_ model: TransactionModel) throws
    func fetchAll() throws -> [TransactionModel]
    func delete(_ model: TransactionModel) throws
}

final class TransactionRepositoryImpl: TransactionRepository{
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func save(_ model: TransactionModel) throws {
        let entity = TransactionEntity(context: context)
        entity.update(with: model)
        try context.save()
    }

    func fetchAll() throws -> [TransactionModel] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let result = try context.fetch(request)
        return result.compactMap { TransactionModel(entity: $0) }
    }

    func delete(_ model: TransactionModel) throws {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        if let entity = try context.fetch(request).first {
            context.delete(entity)
            try context.save()
        }
    }
}

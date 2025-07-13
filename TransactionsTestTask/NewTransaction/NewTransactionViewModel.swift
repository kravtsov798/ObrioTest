//
//  NewTransactionViewModel.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import Foundation

protocol NewTransactionViewModel {

}

final class NewTransactionViewModelImpl: NewTransactionViewModel {
    private let coorfinator: NewTransactionCoordinator
    
    init(coordinator: NewTransactionCoordinator) {
        self.coorfinator = coordinator
    }
}

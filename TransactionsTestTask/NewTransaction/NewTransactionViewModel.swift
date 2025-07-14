//
//  NewTransactionViewModel.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import Foundation

protocol NewTransactionViewModel: NewTransactionViewDelegate {  }

final class NewTransactionViewModelImpl: NewTransactionViewModel {
    private let coordinator: NewTransactionCoordinator
    
    init(coordinator: NewTransactionCoordinator) {
        self.coordinator = coordinator
    }
    
    func addButtonTapped() {
        coordinator.goBack()
    }
}

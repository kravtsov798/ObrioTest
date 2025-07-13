//
//  WalletViewModel.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import Foundation

protocol WalletViewModel {
    
}

final class WalletViewModelImpl: WalletViewModel {
    private let coordinator: WalletCoordinator
    
    init(coordinator: WalletCoordinator) {
        self.coordinator = coordinator
    }
}

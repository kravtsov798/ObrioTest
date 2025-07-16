//
//  AppCoordinator.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let walletCoordinator: WalletCoordinator = WalletCoordinatorImpl(window: window)
        walletCoordinator.start()
    }
}

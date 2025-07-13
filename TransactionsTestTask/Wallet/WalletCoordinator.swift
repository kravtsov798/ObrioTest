//
//  WalletCoordinator.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import UIKit

protocol WalletCoordinator: Coordinator {
    
}

final class WalletCoordinatorImpl: WalletCoordinator {
    private var window: UIWindow?
    private var navigationController: UINavigationController?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let walletViewModel: WalletViewModel = WalletViewModelImpl(coordinator: self)
        let walletViewController = WalletViewController(viewModel: walletViewModel)
        
        navigationController = UINavigationController(rootViewController: walletViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

//
//  AppCoordinator.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    private var window: UIWindow?
    private var navigationController: UINavigationController?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let coordinator: WalletCoordinator = WalletCoordinator()
        let walletViewModel: WalletViewModel = WalletViewModelImpl(coordinator: coordinator)
        let walletViewController = WalletViewController(viewModel: walletViewModel)
        
        navigationController = UINavigationController(rootViewController: walletViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

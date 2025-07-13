//
//  NewTransactionCoordinator.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import UIKit

protocol NewTransactionCoordinator: BackCoordinating, Coordinator {}

final class NewTransactionCoordinatorImpl: NewTransactionCoordinator {
    private var window: UIWindow?
    private var navigationController: UINavigationController? {
        window?.rootViewController as? UINavigationController
    }
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let viewModel: NewTransactionViewModel = NewTransactionViewModelImpl(coordinator: self)
        let viewController = NewTransactionViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

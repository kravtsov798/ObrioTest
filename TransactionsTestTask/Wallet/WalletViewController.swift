//
//  WalletViewController.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import UIKit

final class WalletViewController: UIViewController {
    private typealias ContentView = WalletView
    
    private let viewModel: WalletViewModel
    private var contentView: WalletView? { view as? ContentView }
    
    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = ContentView()
    }
}

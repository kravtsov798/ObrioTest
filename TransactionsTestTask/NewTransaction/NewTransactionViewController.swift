//
//  NewTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import UIKit

final class NewTransactionViewController: UIViewController {
    private typealias ContentView = NewTransactionView
    
    private let viewModel: NewTransactionViewModel
    private var contentView: ContentView? { view as? ContentView }
    
    init(viewModel: NewTransactionViewModel) {
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

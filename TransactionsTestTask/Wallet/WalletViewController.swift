//
//  WalletViewController.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import Combine
import UIKit

final class WalletViewController: UIViewController {
    private typealias ContentView = WalletView
    
    private let viewModel: WalletViewModel
    private var contentView: WalletView? { view as? ContentView }
    private var bag: Set<AnyCancellable> = []
    
    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let contentView = ContentView()
        contentView.delegate = viewModel
        contentView.transactionTableView.dataSource = self
        contentView.transactionTableView.delegate = self
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        bindBitcoinPrice()
        bindBalance()
    }
    
    private func bindBitcoinPrice() {
        viewModel.bitcoinPricePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newPrice in
                //self?.configureNavigationBar(bitcoinRate: newPrice)
                self?.contentView?.update(bitcoinPrice: newPrice)
            }
            .store(in: &bag)
    }
    
    private func bindBalance() {
        viewModel.balancePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newBalance in
                self?.contentView?.update(balance: newBalance)
            }
            .store(in: &bag)
    }
}

extension WalletViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooterView = UITableViewHeaderFooterView()
        
        var configuration = headerFooterView.defaultContentConfiguration()
        configuration.text = viewModel.getSectionTitle(at: section)
        configuration.textProperties.color = .white.withAlphaComponent(0.8)
        
        headerFooterView.contentConfiguration = configuration
        
        return headerFooterView
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.getSectionsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getItemsCount(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel.getItem(for: indexPath.section, at: indexPath.row) else { return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as? TransactionCell
        cell?.update(with: item)
        return cell ?? UITableViewCell()
    }
}

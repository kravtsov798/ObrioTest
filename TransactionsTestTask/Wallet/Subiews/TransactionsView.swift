//
//  TransactionsView.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import UIKit

final class TransactionsView: UIView {
    let tableView = UITableView(frame: .zero, style: .grouped)
    private let transactionsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupSubviews()
        setupSubviewsConstrants()
    }
    
    private func setupSubviews() {
        setupTransactionsLabel()
        setupTableView()
    }
    
    private func setupSubviewsConstrants() {
        setupTransactionsLabelConstraints()
        setupTableViewConstraints()
    }
    
    // MARK: Transactions label
    private func setupTransactionsLabel() {
        transactionsLabel.text = "Transactions"
        transactionsLabel.textAlignment = .left
        transactionsLabel.textColor = .white
        transactionsLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        addSubview(transactionsLabel)
    }
    
    private func setupTransactionsLabelConstraints() {
        transactionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transactionsLabel.topAnchor.constraint(equalTo: topAnchor),
            transactionsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            transactionsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            transactionsLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: Table view
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseIdentifier)
        addSubview(tableView)
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: transactionsLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

//
//  WalletView.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import UIKit

protocol WalletViewDelegate: AnyObject {
    func depositButtonTapped()
    func addTransactionButtonTapped()
}

final class WalletView: UIView {
    weak var delegate: WalletViewDelegate?
    var transactionTableView: UITableView {
        transactionsView.tableView
    }

    private let balanceTitleLabel = UILabel()
    private let bitcoinPriceView = BitcoinPriceView()
    private let balanceLabel = UILabel()
    private let depositButton = UIButton()
    private let addTransactionButton = UIButton()
    private let balanceHStack = UIStackView()
    private let transactionsView = TransactionsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: public interface
    func update(bitcoinPrice: String) {
        bitcoinPriceView.update(price: bitcoinPrice)
    }
    
    func update(balance: String) {
        balanceLabel.text = balance
    }
    
    private func commonInit() {
        setupBackground()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    private func setupBackground() {
        backgroundColor = .darkBlue
    }
    
    private func setupSubviews() {
        setupBalanceTitleLabel()
        setupBitcoinPriceView()
        setupBalanceHStack()
        setupBalanceLabel()
        setupDepositButton()
        setupAddTransactionButton()
        setupTransactionsView()
    }
    
    private func setupSubviewsConstraints() {
        setupBitcoinPriceViewConstraints()
        setupBalanceTitleLabelConstraints()
        setupBalanceHStackConstraints()
        setupBalanceLabelConstraints()
        setupDepositButtonConstraints()
        setupAddTransactionButtonConstraints()
        setupTransactionsViewConstraints()
    }
    
    private func setupBalanceHStack() {
        balanceHStack.axis = .horizontal
        balanceHStack.spacing = 16
        addSubview(balanceHStack)
    }
    
    private func setupBalanceHStackConstraints() {
        balanceHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceHStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            balanceHStack.heightAnchor.constraint(equalToConstant: 44),
            balanceHStack.topAnchor.constraint(equalTo: balanceTitleLabel.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: Balance title label
    private func setupBalanceTitleLabel() {
        balanceTitleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        balanceTitleLabel.text = "Balance"
        balanceTitleLabel.textColor = .white
        balanceTitleLabel.textAlignment = .left
        addSubview(balanceTitleLabel)
    }
    
    private func setupBalanceTitleLabelConstraints() {
        balanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceTitleLabel.topAnchor.constraint(equalTo: bitcoinPriceView.bottomAnchor, constant: 10),
            balanceTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            balanceTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: Bitcoin price view
    private func setupBitcoinPriceView() {
        addSubview(bitcoinPriceView)
    }
    
    private func setupBitcoinPriceViewConstraints() {
        bitcoinPriceView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bitcoinPriceView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            bitcoinPriceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: Balance label
    private func setupBalanceLabel() {
        balanceLabel.font = .systemFont(ofSize: 28, weight: .bold)
        balanceLabel.textColor = .white
        balanceLabel.textAlignment = .left
        balanceHStack.addArrangedSubview(balanceLabel)
    }
    
    private func setupBalanceLabelConstraints() {
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceLabel.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    // MARK: Deposit button
    private func setupDepositButton() {
        depositButton.setTitle("Deposit", for: .normal)
        depositButton.setTitleColor(.white, for: .normal)
        depositButton.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        depositButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        depositButton.addTarget(self, action: #selector(depositButtonTapped), for: .touchUpInside)
        depositButton.backgroundColor = .gold
        depositButton.tintColor = .white
        
        var configutation = UIButton.Configuration.plain()
        configutation.imagePadding = 8
        configutation.background.cornerRadius = 8
        depositButton.configuration = configutation
        
        balanceHStack.addArrangedSubview(depositButton)
    }
    
    @objc
    private func depositButtonTapped() {
        delegate?.depositButtonTapped()
    }
    
    private func setupDepositButtonConstraints() {
        depositButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            depositButton.heightAnchor.constraint(equalToConstant: 44),
           // depositButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: Add transaction button
    private func setupAddTransactionButton() {
        addTransactionButton.setTitle("New transaction", for: .normal)
        addTransactionButton.setTitleColor(.white, for: .normal)
        addTransactionButton.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        addTransactionButton.backgroundColor = .gold
        addTransactionButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addTransactionButton.tintColor = .white

        var configutation = UIButton.Configuration.plain()
        configutation.imagePadding = 8
        configutation.background.cornerRadius = 8
        addTransactionButton.configuration = configutation
        
        addTransactionButton.addTarget(self, action: #selector(addTransactionButtonTapped), for: .touchUpInside)
        addSubview(addTransactionButton)
    }
    
    @objc
    private func addTransactionButtonTapped() {
        delegate?.addTransactionButtonTapped()
    }
    
    private func setupAddTransactionButtonConstraints() {
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTransactionButton.topAnchor.constraint(equalTo: balanceHStack.bottomAnchor, constant: 20),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 44),
            addTransactionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addTransactionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: Transactions view
    private func setupTransactionsView() {
        addSubview(transactionsView)
    }
    
    private func setupTransactionsViewConstraints() {
        transactionsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transactionsView.topAnchor.constraint(equalTo: addTransactionButton.bottomAnchor, constant: 20),
            transactionsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            transactionsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            transactionsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}

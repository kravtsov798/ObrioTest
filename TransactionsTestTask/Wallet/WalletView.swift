//
//  WalletView.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import UIKit

protocol WalletViewDelegate: AnyObject {
    func addTransactionButtonTapped()
}

final class WalletView: UIView {
    weak var delegate: WalletViewDelegate?
    
    private let addTransactionButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupBackground()
        setupAddTransactionButton()
        setupSubviewsConstraints()
    }
    
    private func setupBackground() {
        backgroundColor = .red
    }
    
    private func setupSubviewsConstraints() {
        setupAddTransactionButtonConstraints()
    }
    
    private func setupAddTransactionButton() {
        addTransactionButton.setTitle("New transaction", for: .normal)
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
            addTransactionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addTransactionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 44),
            addTransactionButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}

//
//  BitcoinPriceView.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import UIKit

final class BitcoinPriceView: UIView {
    private let vStack = UIStackView()
    private let bitcoinToUsdLabel = UILabel()
    private let bitcoinPriceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: public interface
    func update(price: String) {
        bitcoinPriceLabel.text = price
    }
    
    private func commonInit() {
        setupVStack()
        setupBitcoinToUSDLabel()
        setupBitcoinPriceLabel()
        setupVStackConstraints()
    }
    
    private func setupVStack() {
        vStack.axis = .horizontal
        vStack.spacing = 8
        vStack.alignment = .trailing
        addSubview(vStack)
    }
    
    private func setupVStackConstraints() {
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupBitcoinToUSDLabel() {
        bitcoinToUsdLabel.text = "BTC/USD"
        bitcoinToUsdLabel.textColor = UIColor(red: 0.84, green: 0.70, blue: 0.21, alpha: 1.00)
        bitcoinToUsdLabel.textAlignment = .right
        bitcoinToUsdLabel.font = .systemFont(ofSize: 14)
        vStack.addArrangedSubview(bitcoinToUsdLabel)
    }

    private func setupBitcoinPriceLabel() {
        bitcoinPriceLabel.font = .systemFont(ofSize: 18)
        bitcoinPriceLabel.textColor = .white
        bitcoinPriceLabel.textAlignment = .right
        vStack.addArrangedSubview(bitcoinPriceLabel)
    }
}

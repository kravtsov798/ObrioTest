//
//  TransactionCell.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import UIKit

final class TransactionCell: UITableViewCell {
    static var reuseIdentifier: String { String(describing: self) }
    
    private let containerView = UIView()
    private let image = UIImageView()
    private let timeLabel = UILabel()
    private let amountLabel = UILabel()
    private let categoryLabel = UILabel()
    private let hStack = UIStackView()
    private let categoryTimeVStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func update(with model: Transaction) {
        image.image = model.image
        
        categoryLabel.text = model.title
        timeLabel.text = model.time
        
        amountLabel.text = model.amount.description
        amountLabel.textColor = model.type == .deposit
        ? UIColor(red: 0.20, green: 0.77, blue: 0.20, alpha: 1.00)
        : UIColor(red: 0.67, green: 0.03, blue: 0.01, alpha: 1.00)
    }
    
    private func commonInit() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    private func setupSubviews() {
        setupContainerView()
        setupHStack()
        setupImage()
        setupCategoryTimeVStack()
        setupCategoryLabel()
        setupTimeLabel()
        setupAmountLabel()
    }
    
    private func setupSubviewsConstraints() {
        setupContainerConstraints()
        setupHStackConstraints()
    }
    
    // MARK: Container view
    private func setupContainerView() {
        containerView.backgroundColor = UIColor(red: 0.41, green: 0.39, blue: 0.73, alpha: 1.00)
        containerView.layer.cornerRadius = 8
        contentView.addSubview(containerView)
    }
    
    private func setupContainerConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    // MARK: Horizontal stack view
    private func setupHStack() {
        hStack.axis = .horizontal
        hStack.backgroundColor = .clear
        hStack.spacing = 16
        hStack.distribution = .fill
        containerView.addSubview(hStack)
    }
    
    private func setupHStackConstraints() {
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            hStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: Amount label
    private func setupAmountLabel() {
        amountLabel.font = .systemFont(ofSize: 17, weight: .bold)
        amountLabel.layer.cornerRadius = 8
        hStack.addArrangedSubview(amountLabel)
    }
    
    private func setupImage() {
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        hStack.addArrangedSubview(image)
    }
    
    private func setupCategoryTimeVStack() {
        categoryTimeVStack.axis = .vertical
        categoryTimeVStack.alignment = .leading
        categoryTimeVStack.spacing = 0
        hStack.addArrangedSubview(categoryTimeVStack)
    }
    
    private func setupCategoryLabel() {
        categoryLabel.textColor = .white
        categoryLabel.font = .systemFont(ofSize: 16, weight: .medium)
        categoryTimeVStack.addArrangedSubview(categoryLabel)
    }
    
    private func setupTimeLabel() {
        timeLabel.textColor = .white.withAlphaComponent(0.8)
        timeLabel.font = .systemFont(ofSize: 14)
        categoryTimeVStack.addArrangedSubview(timeLabel)
    }
}

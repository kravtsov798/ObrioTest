//
//  TransactionCell.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 14.07.2025.
//

import UIKit

final class TransactionCell: UITableViewCell {
    static var reuseIdentifier: String { String(describing: self) }
    static let height: CGFloat = 80
    
    private let containerView = UIView()
    private let categoryImage = UIImageView()
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
        categoryImage.image = nil
        categoryLabel.text = nil
        timeLabel.text = nil
        amountLabel.text = nil
    }
    
    func update(with model: TransactionUIModel) {
        categoryImage.image = model.image
        categoryImage.tintColor = model.accentColor
        categoryLabel.text = model.title
        timeLabel.text = model.time
        amountLabel.text = model.amount
        amountLabel.textColor = model.accentColor
    }
    
    private func commonInit() {
        configureView()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    private func configureView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
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
    
    private func setupContainerView() {
        containerView.backgroundColor = .lightPurple
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
            hStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Layout.hPadding),
            hStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Layout.hPadding)
        ])
    }
    
    private func setupAmountLabel() {
        amountLabel.font = .systemFont(ofSize: 18, weight: .medium)
        amountLabel.layer.cornerRadius = 8
        hStack.addArrangedSubview(amountLabel)
    }
    
    private func setupImage() {
        categoryImage.contentMode = .scaleAspectFit
        categoryImage.tintColor = .white
        hStack.addArrangedSubview(categoryImage)
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

//
//  NewTransactionView.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import UIKit

protocol NewTransactionViewDelegate: AnyObject {
    func addButtonTapped()
}

final class NewTransactionView: UIView {
    weak var delegate: NewTransactionViewDelegate?
    let textField = PaddedTextField()
    let categoryPicker = UIPickerView()
    
    private let amountLabel = UILabel()
    private let categoryLabel = UILabel()
    private let addButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        configureView()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    private func setupSubviews() {
        setupAmountLabel()
        setupTextField()
        setupCategoryLabel()
        setupCategoryPicker()
        setupAddButton()
    }
    
    private func setupSubviewsConstraints() {
        setupAmountLabelConstraints()
        setupTextFiledConstraints()
        setupCategoryLabelConstraints()
        setupCategoryPickerConstraints()
        setupAddButtonConstraints()
    }
    
    private func configureView() {
        backgroundColor = .darkBlue
    }
    
    // MARK: Amount label
    private func setupAmountLabel() {
        configure(label: amountLabel, name: "Amount")
        addSubview(amountLabel)
    }
    
    private func setupAmountLabelConstraints() {
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.hPadding),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.hPadding),
            amountLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    // MARK: Text field
    private func setupTextField() {
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .lightPurple
        textField.textColor = .white
        textField.setPlaceholder("Enter amount", color: .white.withAlphaComponent(0.5))
        addSubview(textField)
    }
    
    private func setupTextFiledConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: Constants.Layout.textFieldHeight),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.hPadding),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.hPadding),
            textField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10)
        ])
    }
    
    // MARK: Category label
    private func setupCategoryLabel() {
        configure(label: categoryLabel, name: "Category")
        addSubview(categoryLabel)
    }
    
    private func setupCategoryLabelConstraints() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.hPadding),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.hPadding),
            categoryLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50)
        ])
    }
    
    // MARK: Category picker
    private func setupCategoryPicker() {
        categoryPicker.backgroundColor = .lightPurple.withAlphaComponent(0.2)
        categoryPicker.layer.cornerRadius = 16
        addSubview(categoryPicker)
    }
    
    private func setupCategoryPickerConstraints() {
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryPicker.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
            categoryPicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.hPadding),
            categoryPicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.hPadding),
        ])
    }
    
    // MARK: Add button
    private func setupAddButton() {
        addButton.layer.cornerRadius = 8
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        addButton.backgroundColor = .gold
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addSubview(addButton)
    }
    
    @objc
    private func addButtonTapped() {
        delegate?.addButtonTapped()
    }
    
    private func setupAddButtonConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.hPadding),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.hPadding),
        ])
    }
    
    private func configure(label: UILabel, name: String) {
        label.text = name
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .medium)
    }
}

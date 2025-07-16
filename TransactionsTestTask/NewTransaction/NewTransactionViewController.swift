//
//  NewTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import UIKit
import Combine

final class NewTransactionViewController: UIViewController {
    private typealias ContentView = NewTransactionView
    
    private let viewModel: NewTransactionViewModel
    private var contentView: ContentView? { view as? ContentView }
    
    private let alertBuilder = ServicesAssembler.alertBuilder()
    private var bag: Set<AnyCancellable> = []
    
    init(viewModel: NewTransactionViewModel) {
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
        contentView.textField.delegate = self
        contentView.categoryPicker.delegate = self
        contentView.categoryPicker.dataSource = self
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        bindData()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "newTransaction.title".localized.uppercased()
    }
    
    private func bindData() {
        bindIsAddButtonEnabled()
        bindErrorMessage()
        bindTextField()
    }
    
    private func bindIsAddButtonEnabled() {
        viewModel.isAddButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.contentView?.enableAddButton(isEnabled)
            }
            .store(in: &bag)
    }
    
    private func bindErrorMessage() {
        viewModel.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.presentErrorAlert(message: message)
            }
            .store(in: &bag)
    }
    
    private func bindTextField() {
        contentView?.textField
            .publisher(for: \.text)
            .sink { [weak self] text in
                guard let text else { return }
                self?.viewModel.amountEntered(text)
            }
            .store(in: &bag)
    }
    
    private func presentErrorAlert(message: String) {
        let alert = alertBuilder
            .addTitle("common.error".localized)
            .addMessage(message)
            .setStyle(.alert)
            .addAction(title: "common.ok".localized, actionStyle: .default) { _ in }
            .build()
        present(alert, animated: true)
    }
}

extension NewTransactionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let localeDecimalSeparator = Locale.current.decimalSeparator ?? "."
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789\(localeDecimalSeparator)")
        let characterSet = CharacterSet(charactersIn: string)
        
        guard allowedCharacters.isSuperset(of: characterSet) else { return false }
        
        let separatorCount = newText.components(separatedBy: localeDecimalSeparator).count - 1
        return separatorCount <= 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.categoriesCount
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let title = viewModel.categoryTitle(at: row)
        return createPickerComponentView(title:title)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.categorySelected(at: row)
    }
    
    private func createPickerComponentView(title: String?) -> UIView {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
}

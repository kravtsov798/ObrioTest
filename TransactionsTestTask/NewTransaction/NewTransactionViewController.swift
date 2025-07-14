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
    
    private let categories = ["Groceries", "Taxi", "Electronics", "Restaurant", "Other"]
    
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
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "New transaction".uppercased()
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
        categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = categories[row]
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
}

//
//  NewTransactionViewModel.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import Foundation
import Combine

protocol NewTransactionViewModel: NewTransactionViewDelegate {
    var isAddButtonEnabled: AnyPublisher<Bool, Never> { get }
    var errorMessagePublisher: AnyPublisher<String, Never> { get }
    
    var categoriesCount: Int { get }
    
    func viewDidAppear()
    func amountEntered(_ amount: String)
    func categoryTitle(at idx: Int) -> String?
    func categorySelected(at idx: Int)
}

final class NewTransactionViewModelImpl: NewTransactionViewModel {
    var isAddButtonEnabled: AnyPublisher<Bool, Never> { isAddButtonEnabledSubject.eraseToAnyPublisher() }
    var errorMessagePublisher: AnyPublisher<String, Never> { errorMessageSubject.eraseToAnyPublisher() }
    
    var categoriesCount: Int { categories.count }
    
    var amount: Double?
    var isAmountValid: Bool {
        guard let amount else { return false }
        guard amount > 0 else { return false }
        return true
    }

    private let categories: [TransactionExpenseCategory] = TransactionExpenseCategory.allCases
    private var selectedCategory: TransactionExpenseCategory? = TransactionExpenseCategory.allCases.first
    
    private let isAddButtonEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    
    private let balanceService = ServicesAssembler.walletBalanceService()
    private let transactionsRepository = ServicesAssembler.transactionRepository()
    private let analyticsService = ServicesAssembler.analyticsService()
    
    private let coordinator: NewTransactionCoordinator
    
    init(coordinator: NewTransactionCoordinator) {
        self.coordinator = coordinator
    }
    
    func viewDidAppear() {
        sendViewOpennedToAnalytics()
    }
    
    func amountEntered(_ amount: String) {
        self.amount = Double(amount.replacingOccurrences(of: ",", with: "."))
        checkIfAddButtonIsEnabled()
    }
    
    func categoryTitle(at idx: Int) -> String? {
        guard categories.indices.contains(idx) else { return nil }
        return categories[idx].title
    }
    
    func categorySelected(at idx: Int) {
        guard categories.indices.contains(idx) else { return }
        selectedCategory = categories[idx]
        checkIfAddButtonIsEnabled()
    }
    
    func addButtonTapped() {
        guard let amount else { return }
        guard balanceService.canWithdraw(funds: amount) else {
            errorMessageSubject.send("error.withdraw".localized)
            sendTransactionFailedToAnalytics(message: "error.withdraw".localized)
            return
        }
        guard let transactionModel = createTransactionModel() else {
            errorMessageSubject.send("error.createTransaction".localized)
            sendTransactionFailedToAnalytics(message: "error.createTransaction".localized)
            return
        }
   
        do {
            try transactionsRepository.save(transactionModel)
            balanceService.withdraw(funds: amount)
            sendTransactionCreatedToAnalytics(model: transactionModel)
            coordinator.goBack()
        } catch {
            errorMessageSubject.send("error.createTransaction".localized)
            sendTransactionFailedToAnalytics(message: "error.createTransaction".localized)
        }
    }
    
    private func checkIfAddButtonIsEnabled() {
        let isValid = selectedCategory != nil && isAmountValid
        isAddButtonEnabledSubject.send(isValid)
    }
    
    private func createTransactionModel() -> TransactionModel? {
        guard let amount else { return nil }
        return TransactionModel(
            id: UUID(),
            date: .now,
            type: .expense,
            category: selectedCategory,
            amount: amount
        )
    }
    
    private func sendViewOpennedToAnalytics() {
        analyticsService.trackEvent(name: AnalyticsEventName.screenOpen, parameters: ["screen": "New transaction"])
    }
    
    private func sendTransactionCreatedToAnalytics(model: TransactionModel) {
        var parameters: [String: String]  = ["type": "\(model.type.rawValue)",
                                             "amount": "\(model.amount)",
                                             "date": "\(model.date)" ]
        if let category = model.category {
            parameters["category"] = "\(category.rawValue)"
        }
        
        analyticsService.trackEvent(name: AnalyticsEventName.transactionCreated,
                                    parameters: parameters)
    }
    
    private func sendTransactionFailedToAnalytics(message: String) {
        analyticsService.trackEvent(name: AnalyticsEventName.transactionCreatedFailed, parameters: ["error": message])
    }
}

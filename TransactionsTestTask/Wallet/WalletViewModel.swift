//
//  WalletViewModel.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import Combine
import Foundation
import UIKit

protocol WalletViewModel: WalletViewDelegate {
    var bitcoinRatePublisher: AnyPublisher<String, Never> { get }
    var balancePublisher: AnyPublisher<String, Never> { get }
    var showDepositPopupPublisher: AnyPublisher<Void, Never> { get }
    
    func viewDidAppear()
    func depositEntered(_ amount: String)
}

final class WalletViewModelImpl: WalletViewModel {
    var bitcoinRatePublisher: AnyPublisher<String, Never> { bitcoinRateSubject.eraseToAnyPublisher() }
    var balancePublisher: AnyPublisher<String, Never> { balanceSubject.eraseToAnyPublisher() }
    var showDepositPopupPublisher: AnyPublisher<Void, Never> { showDepositPopupSubject.eraseToAnyPublisher() }
    
    private let bitcoinRateSubject: CurrentValueSubject<String, Never> = .init("")
    private let balanceSubject: CurrentValueSubject<String, Never> = .init("")
    private let showDepositPopupSubject: PassthroughSubject<Void, Never> = .init()
    
    private let balanceService = ServicesAssembler.walletBalanceService()
    private let bitcoinRateService = ServicesAssembler.bitcoinRateService()
    private let transactionRepository = ServicesAssembler.transactionRepository()
    private let analyticsService = ServicesAssembler.analyticsService()
    private let coordinator: WalletCoordinator
    
    private var bag: Set<AnyCancellable> = []
    
    init(coordinator: WalletCoordinator) {
        self.coordinator = coordinator
        bindData()
    }
    
    func depositButtonTapped() {
        showDepositPopupSubject.send()
    }
    
    func addTransactionButtonTapped() {
        coordinator.goToNewTransaction()
    }
    
    func viewDidAppear() {
        sendViewOpennedToAnalytics()
    }
    
    func depositEntered(_ amount: String) {
        guard let deposit = amount.double else { return }
        
        let model = TransactionModel(
            id: UUID(),
            date: .now,
            type: .income,
            category: nil,
            amount: deposit
        )
        
        try? transactionRepository.save(model)
        balanceService.add(funds: deposit)
        sendTransactionCreatedToAnalytics(model: model)
    }
    
    private func bindData() {
        bindBitcoinRate()
        bindWalletBalance()
    }
    
    private func bindBitcoinRate() {
        bitcoinRateService.ratePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0.formattedCurrencyString() }
            .map { "$" + $0 }
            .sink { [weak self] rate in
                self?.sendRateToAnalytics(rate)
                self?.bitcoinRateSubject.send(rate)
            }
            .store(in: &bag)
    }
    
    private func bindWalletBalance() {
        balanceService.balancePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0.formattedCurrencyString() }
            .map { $0 + "BTC" }
            .sink { [weak self] balance in
                self?.balanceSubject.send(String(balance))
            }
            .store(in: &bag)
    }
    
    private func sendViewOpennedToAnalytics() {
        analyticsService.trackEvent(name: AnalyticsEventName.screenOpen, parameters: ["screen": "Wallet"])
    }
    
    private func sendRateToAnalytics(_ rate: String) {
        analyticsService.trackEvent(name: AnalyticsEventName.bitcoinRateUpdate, parameters: ["rate": rate])
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
}

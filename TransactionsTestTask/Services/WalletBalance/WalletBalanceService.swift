//
//  WalletBalanceService.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 15.07.2025.
//

import Combine
import Foundation

protocol WalletBalanceService {
    var balance: Double { get }
    var balancePublisher: AnyPublisher<Double, Never> { get }
    
    func add(funds: Double)
    func canWithdraw(funds: Double) -> Bool
    func withdraw(funds: Double)
}

final class WalletBalanceServiceImpl: WalletBalanceService {
    var balance: Double { balanceSubject.value }
    var balancePublisher: AnyPublisher<Double, Never> {
        balanceSubject
            .print()
            .eraseToAnyPublisher()
    }
   
    private let balanceSubject: CurrentValueSubject<Double, Never>
    private let repository: WalletBalanceRepository
    
    init(repository: WalletBalanceRepository) {
        self.repository = repository
        balanceSubject = .init(repository.load() ?? 0)
    }
    
    func add(funds: Double) {
        balanceSubject.send(balance + funds)
        saveBalance()
    }
    
    func canWithdraw(funds: Double) -> Bool {
        balance - funds >= 0
    }
    
    func withdraw(funds: Double) {
        balanceSubject.send(balance - funds)
        saveBalance()
    }
     
    private func saveBalance() {
        repository.save(balance)
    }
}

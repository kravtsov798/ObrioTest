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
    static let shared = WalletBalanceServiceImpl()
    
    var balance: Double { balanceSubject.value }
    var balancePublisher: AnyPublisher<Double, Never> {
        balanceSubject
            .print()
            .eraseToAnyPublisher()
    }
   
    private var balanceSubject: CurrentValueSubject<Double, Never>
    
    private let repository = ServicesAssembler.walletBalanceRepository()
    
    private init() {
        balanceSubject = .init(repository.load() ?? 100)
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

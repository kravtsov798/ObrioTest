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
    var bitcoinPricePublisher: AnyPublisher<String, Never> { get }
    var balancePublisher: AnyPublisher<String, Never> { get }
    
    func getSectionTitle(at idx: Int) -> String?
    func getSectionsCount() -> Int
    func getItemsCount(inSection: Int) -> Int
    func getItem(for sectionIdx: Int, at rowIdx: Int) -> Transaction?
}

final class WalletViewModelImpl: WalletViewModel {
    var bitcoinPricePublisher: AnyPublisher<String, Never> { bitcoinSubject.eraseToAnyPublisher() }
    var balancePublisher: AnyPublisher<String, Never> { balanceSubject.eraseToAnyPublisher() }
    
    private var sections: [TransactionsSection] = TransactionsSection.mocked
    
    //MARK: subjects
    private let bitcoinSubject: CurrentValueSubject<String, Never> = .init("$118.650")
    private let balanceSubject: CurrentValueSubject<String, Never> = .init("0.00001 BTC")
    
    private let bitcoinPriceProvider: BitcoinPriceProvider = BitcoinPriceProviderImpl()
    private let coordinator: WalletCoordinator
    
    init(coordinator: WalletCoordinator) {
        self.coordinator = coordinator
        fetchData()
    }
    
    func getSectionTitle(at idx: Int) -> String? {
        guard sections.indices.contains(idx) else { return nil }
        return sections[idx].title
    }
    
    func getSectionsCount() -> Int {
        sections.count
    }
    
    func getItemsCount(inSection idx: Int) -> Int {
        guard sections.indices.contains(idx) else { return 0 }
        return sections[idx].items.count
    }
    
    func getItem(for sectionIdx: Int, at rowIdx: Int) -> Transaction? {
        guard sections.indices.contains(sectionIdx),
              sections[sectionIdx].items.indices.contains(rowIdx)
        else { return nil }
        return self.sections[sectionIdx].items[rowIdx]
    }
    
    func depositButtonTapped() {
        
    }
    
    func addTransactionButtonTapped() {
        coordinator.goToNewTransaction()
    }
    
    private func fetchData() {
        Task {
            do {
                let response = try await bitcoinPriceProvider.getPrice()
                await handle(bitcoinPriceResponse: response)
            } catch {
                await handle(error: error)
            }
        }
    }
    
    @MainActor
    private func handle(bitcoinPriceResponse: BitcoinPriceResponse) {
        print("response: \(bitcoinPriceResponse)")
    }
    
    @MainActor
    private func handle(error: Error) {
        print("fetch error: \(error)")
    }
}

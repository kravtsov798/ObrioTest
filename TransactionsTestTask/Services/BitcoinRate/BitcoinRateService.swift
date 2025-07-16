//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

/// Rate Service should fetch data from https://api.coindesk.com/v1/bpi/currentprice.json
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// Every successful fetch should be logged with analytics service
/// The service should be covered by unit tests

import Combine
import Foundation

protocol BitcoinRateService: AnyObject {
    var rate: Double { get }
    var ratePublisher: AnyPublisher<Double, Never> { get }
}

final class BitcoinRateServiceImpl: BitcoinRateService {
    var rate: Double { rateSubject.value }
    var ratePublisher: AnyPublisher<Double, Never> { rateSubject.eraseToAnyPublisher() }
    
    private let timerInterval: TimeInterval = 180
    
    private let rateSubject: CurrentValueSubject<Double, Never> = .init(0)
    
    private let repository = ServicesAssembler.bitcoinRateRepository()
    private let provider = ServicesAssembler.bitcoinRateProvider()
    
    private var bag: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init() {
        loadCachedRate()
        startTimer()
        fetchRate()
    }
    
    private func loadCachedRate() {
        guard let rate = repository.load() else { return }
        rateSubject.send(rate)
    }
    
    private func startTimer() {
         Timer
             .publish(every: timerInterval, on: .main, in: .common)
             .autoconnect()
             .sink { [weak self] _ in
                 self?.fetchRate()
             }
             .store(in: &bag)
     }
    
    private func fetchRate() {
        Task {
            do {
                let response = try await provider.getRate()
                await handle(rateResponse: response)
            } catch {
                await handle(error: error)
            }
        }
    }
    
    @MainActor
    private func handle(rateResponse: BitcoinRateResponse) {
        guard let rate = Double(rateResponse.amount) else { return }
        repository.save(rate)
        rateSubject.send(rate)
    }
    
    @MainActor
    private func handle(error: Error) {
        print("Cannot fetch rate: \(error)")
    }
}

//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

/// Services Assembler is used for Dependency Injection
/// There is an example of a _bad_ services relationship built on `onRateUpdate` callback
/// This kind of relationship must be refactored with a more convenient and reliable approach
///
/// It's ok to move the logging to model/viewModel/interactor/etc when you have 1-2 modules in your app
/// Imagine having rate updates in 20-50 diffent modules
/// Make this logic not depending on any module
enum ServicesAssembler {
    
    // MARK: - Bitcoin rate
    
    static let bitcoinRateService: PerformOnce<BitcoinRateService> = {
        { BitcoinRateServiceImpl() }
    }()
    
    static let bitcoinRateRepository: PerformOnce<BitcoinRateRepository> = {
        { BitcoinRateRepositoryImpl(context: CoreDataStack.shared.context) }
    }()
    
    static let bitcoinRateProvider: PerformOnce<BitcoinRateProvider> = {
        { BitcoinRateProviderImpl() }
    }()
    
    // MARK: - Wallet balance
    
    static let walletBalanceService: PerformOnce<WalletBalanceService> = {
        { WalletBalanceServiceImpl.shared }
    }()
    
    static let walletBalanceRepository: PerformOnce<WalletBalanceRepository> = {
        { WalletBalanceRepositoryImpl(context: CoreDataStack.shared.context) }
    }()
    
    // MARK: - Transaction repository
    
    static let transactionRepository: PerformOnce<TransactionRepository> = {
        { TransactionRepositoryImpl(context: CoreDataStack.shared.context) }
    }()
    
    // MARK: - AnalyticsService
    
    static let analyticsService: PerformOnce<AnalyticsService> = {
        let service = AnalyticsServiceImpl()
        
        return { service }
    }()
    
    // MARK: - Alert builder
    
    static let alertBuilder: PerformOnce<AlertBuilder> = {
        { AlertBuilderImpl() }
    }()
}

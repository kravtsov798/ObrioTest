//
//  WalletViewController.swift
//  TransactionsTestTask
//
//  Created by Andrii Kravtsov on 13.07.2025.
//

import Combine
import UIKit
import CoreData

final class WalletViewController: UIViewController {
    private var contentView: WalletView? { view as? WalletView }
    private var tableView: UITableView? { contentView?.transactionTableView }
    
    private var fetchedResultsController: NSFetchedResultsController<TransactionEntity>?
    private let viewModel: WalletViewModel
    private let alertBuilder = ServicesAssembler.alertBuilder()
    private var bag: Set<AnyCancellable> = []
    
    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let contentView = WalletView()
        contentView.delegate = viewModel
        contentView.transactionTableView.dataSource = self
        contentView.transactionTableView.delegate = self
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultController()
        bindViewModel()
        try? fetchedResultsController?.performFetch()
    }
    
    private func setupFetchedResultController() {
        let request = TransactionEntity.fetchRequest()
        request.fetchBatchSize = 20
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataStack.shared.context,
            sectionNameKeyPath: "sectionDate",
            cacheName: nil
        )
        fetchedResultsController?.delegate = self
    }
    
    private func bindViewModel() {
        bindBitcoinRate()
        bindBalance()
        bindShowDepositAlert()
    }
    
    private func bindBitcoinRate() {
        viewModel.bitcoinRatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newPrice in
                self?.contentView?.update(bitcoinPrice: newPrice)
            }
            .store(in: &bag)
    }
    
    private func bindBalance() {
        viewModel.balancePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newBalance in
                self?.contentView?.update(balance: newBalance)
            }
            .store(in: &bag)
    }
    
    private func bindShowDepositAlert() {
        viewModel.showDepositPopupPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.presentTopUpAlert()
            }
            .store(in: &bag)
    }
     
    private func presentTopUpAlert() {
        let alert = alertBuilder
            .addTitle("topUpBalance.title".localized)
            .addMessage("topUpBalance.enterAmoun".localized)
            .setStyle(.alert)
            .addAction(title: "common.cancel".localized, actionStyle: .cancel, handler: { _ in })
            .build()

        alert.addTextField { textField in
            textField.keyboardType = .decimalPad
            textField.placeholder = "topUpBalance.placehalder".localized
        }
        
        let confirm = UIAlertAction(title: "common.add".localized, style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text else { return }
            self?.viewModel.depositEntered(text)
        }
        
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}

// MARK: - confirm UITableViewDataSource, UITableViewDelegate
extension WalletViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        TransactionCell.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = fetchedResultsController?.sections?[section].name else { return nil }
 
        let headerFooterView = UITableViewHeaderFooterView()
        
        var configuration = headerFooterView.defaultContentConfiguration()
        configuration.text = title
        configuration.textProperties.color = .white.withAlphaComponent(0.8)
        
        headerFooterView.contentConfiguration = configuration
        return headerFooterView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let entity = fetchedResultsController?.object(at: indexPath),
              let uiModel = TransactionMapper.mapEntityToUIModel(entity)
        else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TransactionCell.reuseIdentifier,
            for: indexPath
        ) as? TransactionCell
        
        cell?.update(with: uiModel)
        return cell ?? UITableViewCell()
    }
}

// MARK: - confirm NSFetchedResultsControllerDelegate
extension WalletViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
          switch type {
          case .insert:
              if let newIndexPath = newIndexPath {
                  tableView?.insertRows(at: [newIndexPath], with: .automatic)
              }
          case .delete:
              if let indexPath = indexPath {
                  tableView?.deleteRows(at: [indexPath], with: .automatic)
              }
          case .update:
              if let indexPath = indexPath {
                  tableView?.reloadRows(at: [indexPath], with: .automatic)
              }
          case .move:
              if let indexPath = indexPath, let newIndexPath = newIndexPath {
                  tableView?.moveRow(at: indexPath, to: newIndexPath)
              }
          @unknown default:
              break
          }
      }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType ) {
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert: tableView?.insertSections(indexSet, with: .automatic)
        case .delete: tableView?.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}

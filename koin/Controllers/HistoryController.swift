//
//  HistoryController.swift
//  koin
//
//  Created by Jaroslav Hampejs on 12/03/2021.
//

import Foundation
import UIKit
import CoreData

enum TransactionSymbol: String {
    case incoming = "→"
    case outgoing = "←"
}

class HistoryController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let numberFormatter = NumberFormatter()
    let dateFormatter: DateFormatter = DateFormatter()
    var dateComponentDays: DateComponents = DateComponents()
    var dateComponentMonts: DateComponents = DateComponents()
    var transactions: [Transaction] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredTransactions: [Transaction] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    var fullView: Bool = true
    var changed: Bool = false {
        didSet {
            fetchTransactions()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delaysContentTouches = false
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Transactions"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if (transactions.isEmpty) {
            fetchTransactions()            
        }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        //dateFormatter.dateFormat = "d. M. yyyy"
        dateComponentDays.day = -7
        dateComponentMonts.month = -1
        
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
    }
    
    func fetchTransactions() {
        do {
            //print("FETCHING")
            let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sortDescriptor]
            self.transactions = try context.fetch(request)
            
            if (title == "Last Month") {
                transactions = transactions.filter { $0.date ?? Date() > Calendar.current.date(byAdding: dateComponentMonts, to: Date())! }
            } else if (title == "Last Week") {
                transactions = transactions.filter { $0.date ?? Date() > Calendar.current.date(byAdding: dateComponentDays, to: Date())! }
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            print("ERROR FETCHING TRANSACTIONS")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTransactions.count
        }
        
        return transactions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let transaction: Transaction
        
        if isFiltering {
            transaction = filteredTransactions[indexPath.row] as Transaction
        } else {
            transaction = transactions[indexPath.row] as Transaction
        }
        
        cell.transactionTitle.text = transaction.title
        cell.counterparty.text = transaction.counterparty
        cell.date.text = dateFormatter.string(from: transaction.date ?? Date())
        cell.total.text = numberFormatter.string(from: NSNumber(value: transaction.total))
        cell.symbol.text = transaction.incoming ? TransactionSymbol.incoming.rawValue : TransactionSymbol.outgoing.rawValue
        cell.symbol.textColor = transaction.incoming ? .systemGreen : .systemOrange
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 100.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TransactionDetailController
        if let indexPath = collectionView.indexPathsForSelectedItems?.first{
            let overviewController = (tabBarController?.viewControllers?.first)?.children.first as! OverviewController
            let statsController = (tabBarController?.viewControllers?[1])?.children.first as! StatsController
            let fullHistoryController = (tabBarController?.viewControllers?[2])?.children.first as! HistoryController
            let transaction = transactions[indexPath.row]
            controller.passedTransaction = transaction
            
            if (fullView == true) {
                controller.historyVC = self
                controller.overviewVC = overviewController
                controller.statsVC = statsController
            } else {
                controller.lastVC = self
                controller.overviewVC = overviewController
                controller.historyVC = fullHistoryController
                controller.statsVC = statsController
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let formController = storyboard.instantiateViewController(identifier: "TransactionFormController") as! TransactionFormController
        let overviewController = (tabBarController?.viewControllers?.first)?.children.first as! OverviewController
        let statsController = (tabBarController?.viewControllers?[1])?.children.first as! StatsController
        let fullHistoryController = (tabBarController?.viewControllers?[2])?.children.first as! HistoryController
        
        if (fullView == true) {
            formController.historyVC = self
            formController.overviewVC = overviewController
            formController.statsVC = statsController
        } else {
            formController.lastVC = self
            formController.overviewVC = overviewController
            formController.historyVC = fullHistoryController
            formController.statsVC = statsController
        }
        
        present(formController, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "all") {
        filteredTransactions = transactions.filter {
            (transaction: Transaction) -> Bool in
            return (transaction.title?.lowercased().contains(searchText.lowercased()) ?? false)
        }
        
        collectionView.reloadData()
    }
    
    @IBAction func unwindToController(segue: UIStoryboardSegue) {
    }
}

extension HistoryController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

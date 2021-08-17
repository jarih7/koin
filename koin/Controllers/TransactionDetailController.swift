//
//  TransactionDetailController.swift
//  koin
//
//  Created by Jaroslav Hampejs on 13/03/2021.
//

import Foundation
import UIKit

class TransactionDetailController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var transactionTitle: UILabel!
    @IBOutlet weak var optionsButton: UIBarButtonItem!
    @IBOutlet weak var transactionCounterparty: UILabel!
    @IBOutlet weak var transactionTotal: UILabel!
    @IBOutlet weak var transactionSymbol: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var historyVC: HistoryController? = nil
    var overviewVC: OverviewController? = nil
    var lastVC: HistoryController? = nil
    var passedTransaction: Transaction? = nil
    let dateFormatter: DateFormatter = DateFormatter()
    let numberFormatter = NumberFormatter()
    
    var changed: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.drawData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        //dateFormatter.dateFormat = "d. M. yyyy"
        
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        drawData()
    }
    
    func drawData() {
        transactionTitle.text = passedTransaction?.title ?? "no data"
        transactionCounterparty.text = passedTransaction?.counterparty ?? "no data"
        transactionDate.text = dateFormatter.string(from: passedTransaction?.date ?? Date())
        //transactionTotal.text = String(format: "%.2f", passedTransaction?.total ?? 0.0)
        transactionTotal.text = numberFormatter.string(from: NSNumber(value: passedTransaction?.total ?? 0.0))
        
        if (passedTransaction?.incoming == true) {
            transactionSymbol.text = TransactionSymbol.incoming.rawValue
            transactionSymbol.textColor = .systemGreen
        } else {
            transactionSymbol.text = TransactionSymbol.outgoing.rawValue
            transactionSymbol.textColor = .systemOrange
        }
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Transaction Options", message: "What do you want to do with this Transaction?", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [self] (UIAlertAction) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let formController = storyboard.instantiateViewController(identifier: "TransactionFormController") as! TransactionFormController
            formController.passedTransaction = passedTransaction
            formController.overviewVC = overviewVC
            formController.historyVC = historyVC
            formController.lastVC = lastVC
            formController.detailVC = self
            present(formController, animated: true, completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [self] (UIAlertAction) in
            
            if let transactionToDelete = passedTransaction {
                context.delete(transactionToDelete)
            }
            
            do {
                try context.save()
                lastVC?.changed = true
                historyVC?.changed = true
                overviewVC?.changed = true
            } catch {
                print("ERROR SAVING CONTEXT")
            }
            
            navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

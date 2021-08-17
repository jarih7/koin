//
//  OverviewController.swift
//  koin
//
//  Created by Jaroslav Hampejs on 16/03/2021.
//

import Foundation
import UIKit
import CoreData

class OverviewController: UIViewController, UINavigationBarDelegate {
    @IBOutlet weak var lastMonthView: LastMonthView!
    @IBOutlet weak var lastWeekView: LastWeekView!
    @IBOutlet weak var lastTransactionView: LastTransactionView!
    @IBOutlet weak var lastTransactionSectionHeader: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var lastMonthIn: Double = 0
    var lastMonthOut: Double = 0
    var lastWeekIn: Double = 0
    var lastWeekOut: Double = 0
    
    let dateFormatter: DateFormatter = DateFormatter()
    var dateComponentDays: DateComponents = DateComponents()
    var dateComponentMonts: DateComponents = DateComponents()
    
    let numberFormatter = NumberFormatter()
    
    var transactions: [Transaction] = []
    var lastMonthTransactions: [Transaction] = []
    var lastWeekTransactions: [Transaction] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var changed: Bool = false {
        didSet {
            self.drawData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delaysContentTouches = false
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        //dateFormatter.dateFormat = "d. M. yyyy"
        dateComponentDays.day = -7
        dateComponentMonts.month = -1
        
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.init(identifier: "en_US")
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        
        drawData()
    }
    
    func computeData() {
        lastMonthIn = 0
        lastMonthOut = 0
        lastWeekIn = 0
        lastWeekOut = 0
        lastWeekTransactions = []
        lastMonthTransactions = []
        
        for tr in transactions {
            if (tr.date ?? Date() > Calendar.current.date(byAdding: dateComponentDays, to: Date())!) {
                //last week (and month) transaction
                lastWeekTransactions.append(tr)
                lastMonthTransactions.append(tr)
                if (tr.incoming == true) {
                    lastWeekIn += tr.total
                    lastMonthIn += tr.total
                } else {
                    lastWeekOut += tr.total
                    lastMonthOut += tr.total
                }
            } else if (tr.date ?? Date() > Calendar.current.date(byAdding: dateComponentMonts, to: Date())!) {
                //last month only transaction
                lastMonthTransactions.append(tr)
                if (tr.incoming == true) {
                    lastMonthIn += tr.total
                } else {
                    lastMonthOut += tr.total
                }
            }
        }
    }
    
    func drawData() {
        do {
            //print("FETCHING")
            let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sortDescriptor]
            self.transactions = try context.fetch(request)
            computeData()
            
            DispatchQueue.main.async { [self] in
                lastMonthView.fromDate.text = dateFormatter.string(from: Calendar.current.date(byAdding: dateComponentMonts, to: Date())!)
                lastMonthView.toDate.text = dateFormatter.string(from: Date())
                lastMonthView.monthInSum.text = numberFormatter.string(from: NSNumber(integerLiteral: Int(lastMonthIn)))
                lastMonthView.monthOutSum.text = numberFormatter.string(from: NSNumber(integerLiteral: Int(lastMonthOut)))
                lastMonthView.monthBalance.text = numberFormatter.string(from: NSNumber(integerLiteral: Int(lastMonthIn - lastMonthOut)))
                
                lastWeekView.fromDate.text = dateFormatter.string(from: Calendar.current.date(byAdding: dateComponentDays, to: Date())!)
                lastWeekView.toDate.text = dateFormatter.string(from: Date())
                lastWeekView.weekInSum.text = numberFormatter.string(from: NSNumber(integerLiteral: Int(lastWeekIn)))
                lastWeekView.weekOutSum.text = numberFormatter.string(from: NSNumber(integerLiteral: Int(lastWeekOut)))
                lastWeekView.weekBalance.text = numberFormatter.string(from: NSNumber(integerLiteral: Int(lastWeekIn - lastWeekOut)))
                
                lastTransactionView.ltTitle.text = transactions.first?.title ?? "no data"
                lastTransactionView.ltIncomingSymbol.text = transactions.first?.incoming ?? false ? "→" : "←"
                lastTransactionView.ltIncomingSymbol.textColor = transactions.first?.incoming ?? false ? .systemGreen : .systemOrange
                lastTransactionView.ltTotal.text = numberFormatter.string(from: NSNumber(integerLiteral: Int(transactions.first?.total ?? 0)))
                
                lastTransactionView.ltCounterparty.text = transactions.first?.counterparty ?? "no data"
                lastTransactionView.ltDate.text = dateFormatter.string(from: transactions.first?.date ?? Date())
                
                if (transactions.isEmpty) {
                    lastTransactionView.isHidden = true
                    lastTransactionSectionHeader.text = "no transactions"
                } else {
                    lastTransactionView.isHidden = false
                    lastTransactionSectionHeader.text = "Last Transaction"
                }
            }
        } catch {
            print("ERROR FETCHING TRANSACTIONS")
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let formController = storyBoard.instantiateViewController(identifier: "TransactionFormController") as! TransactionFormController
        let fullHistoryController = (tabBarController?.viewControllers?[2])?.children.first as! HistoryController
        formController.historyVC = fullHistoryController
        formController.overviewVC = self
        present(formController, animated: true, completion: nil)
    }
    
    @IBAction func lastMonthTapped(_ sender: LastMonthView) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let lastMonthController = storyBoard.instantiateViewController(identifier: "HistoryController") as! HistoryController
        lastMonthController.fullView = false
        lastMonthController.title = "Last Month"
        lastMonthController.transactions = lastMonthTransactions
        show(lastMonthController, sender: self)
    }
    
    @IBAction func lastWeekTapped(_ sender: LastWeekView) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let lastWeekController = storyBoard.instantiateViewController(identifier: "HistoryController") as! HistoryController
        lastWeekController.fullView = false
        lastWeekController.title = "Last Week"
        lastWeekController.transactions = lastWeekTransactions
        show(lastWeekController, sender: self)
    }
    
    @IBAction func lastTransactionTapped(_ sender: LastTransactionView) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let transactionDetailController = storyBoard.instantiateViewController(identifier: "TransactionDetailController") as! TransactionDetailController
        let fullHistoryController = (tabBarController?.viewControllers?[2])?.children.first as! HistoryController
        transactionDetailController.passedTransaction = transactions.first
        transactionDetailController.overviewVC = self
        transactionDetailController.historyVC = fullHistoryController
        show(transactionDetailController, sender: self)
    }
}

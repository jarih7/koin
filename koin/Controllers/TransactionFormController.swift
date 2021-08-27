//
//  TransactionFormController.swift
//  koin
//
//  Created by Jaroslav Hampejs on 13/03/2021.
//

import Foundation
import UIKit
import CoreData

class TransactionFormController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var counterpartyField: UITextField!
    @IBOutlet weak var totalField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerBackground: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var titleBGView: UIView!
    @IBOutlet weak var counterpartyBGView: UIView!
    @IBOutlet weak var totalBGView: UIView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var detailVC: TransactionDetailController? = nil
    var historyVC: HistoryController? = nil
    var overviewVC: OverviewController? = nil
    var statsVC: StatsController? = nil
    var lastVC: HistoryController? = nil
    var passedTransaction: Transaction? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("detailVC: \(String(describing: detailVC))")
        print("historyVC: \(String(describing: historyVC))")
        print("overviewVC: \(String(describing: overviewVC))")
        print("statsVC: \(String(describing: statsVC))")
        print("lastVC: \(String(describing: lastVC))")
        
        let tapAway = UITapGestureRecognizer(target: self.view, action: #selector(UITextField.endEditing(_:)))
        view.addGestureRecognizer(tapAway)
        
        titleBGView.layer.cornerRadius = 8
        counterpartyBGView.layer.cornerRadius = 8
        totalBGView.layer.cornerRadius = 8
        
        datePickerBackground.layer.masksToBounds = false
        datePickerBackground.layer.cornerRadius = 8
        
        saveButton.layer.masksToBounds = false
        saveButton.layer.cornerRadius = 8
        
        segmentedControl.selectedSegmentIndex = 1
        
        //got a transaction
        if let transaction = passedTransaction {
            segmentedControl.selectedSegmentIndex = transaction.incoming ? 0 : 1
            titleField.text = transaction.title
            counterpartyField.text = transaction.counterparty
            totalField.text = transaction.total.description
            datePicker.date = transaction.date ?? Date()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if (passedTransaction == nil) {
            //creating NEW TRANSACTION
            let newTransaction: Transaction = Transaction(context: self.context)
            newTransaction.incoming = segmentedControl.selectedSegmentIndex == 0 ? true : false
            newTransaction.title = titleField.text
            newTransaction.counterparty = counterpartyField.text
            newTransaction.total = Double(totalField.text?.replacingOccurrences(of: ",", with: ".") ?? "0") ?? 0
            newTransaction.date = datePicker.date
            
            do {
                try context.save()
                print("statsVC: \(String(describing: statsVC))")
                historyVC?.changed = true
                overviewVC?.changed = true
                statsVC?.changed = true
                lastVC?.changed = true
            } catch {
                print("ERROR SAVING CONTEXT")
            }
        } else {
            //updating EXISTING TRANSACTION
            passedTransaction?.incoming = segmentedControl.selectedSegmentIndex == 0 ? true : false
            passedTransaction?.title = titleField.text
            passedTransaction?.counterparty = counterpartyField.text
            passedTransaction?.total = Double(totalField.text?.replacingOccurrences(of: ",", with: ".") ?? "0") ?? 0
            passedTransaction?.date = datePicker.date
            detailVC?.passedTransaction = passedTransaction
            
            do {
                try context.save()
                detailVC?.changed = true
                historyVC?.changed = true
                overviewVC?.changed = true
                statsVC?.changed = true
                lastVC?.changed = true
            } catch {
                print("ERROR SAVING CONTEXT")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

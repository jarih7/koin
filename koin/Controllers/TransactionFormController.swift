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
    var lastVC: HistoryController? = nil
    var passedTransaction: Transaction? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("detailVC: \(String(describing: detailVC))")
        print("historyVC: \(String(describing: historyVC))")
        print("overviewVC: \(String(describing: overviewVC))")
        print("lastVC: \(String(describing: lastVC))")
        
        let tapAway = UITapGestureRecognizer(target: self.view, action: #selector(UITextField.endEditing(_:)))
        view.addGestureRecognizer(tapAway)
        
        //titleBGView.clipsToBounds = true
        titleBGView.layer.cornerRadius = 8
        //counterpartyBGView.clipsToBounds = true
        counterpartyBGView.layer.cornerRadius = 8
        //totalBGView.clipsToBounds = true
        totalBGView.layer.cornerRadius = 8
        
        //datePickerBackground.clipsToBounds = true
        datePickerBackground.layer.masksToBounds = false
        datePickerBackground.layer.cornerRadius = 8
        //datePickerBackground.layer.shadowRadius = 5
        //datePickerBackground.layer.shadowOpacity = 0.1
        //datePickerBackground.layer.shadowColor = UIColor.black.cgColor
        //datePickerBackground.layer.shadowOffset = CGSize(width: 0, height: 1)
        //datePickerBackground.layer.shadowPath = UIBezierPath(roundedRect: datePickerBackground.bounds, cornerRadius: 8).cgPath
        
        //saveButton.clipsToBounds = true
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
            let newTransaction: Transaction = Transaction(context: self.context)
            newTransaction.incoming = segmentedControl.selectedSegmentIndex == 0 ? true : false
            newTransaction.title = titleField.text
            newTransaction.counterparty = counterpartyField.text
            newTransaction.total = Double(totalField.text?.replacingOccurrences(of: ",", with: ".") ?? "0") ?? 0
            newTransaction.date = datePicker.date
            
            do {
                try self.context.save()
                self.historyVC?.changed = true
                self.overviewVC?.changed = true
                self.lastVC?.changed = true
            } catch {
                print("ERROR SAVING CONTEXT")
            }
        } else {
            passedTransaction?.incoming = segmentedControl.selectedSegmentIndex == 0 ? true : false
            passedTransaction?.title = titleField.text
            passedTransaction?.counterparty = counterpartyField.text
            passedTransaction?.total = Double(totalField.text?.replacingOccurrences(of: ",", with: ".") ?? "0") ?? 0
            passedTransaction?.date = datePicker.date
            detailVC?.passedTransaction = passedTransaction
            
            do {
                try self.context.save()
                self.detailVC?.changed = true
                self.historyVC?.changed = true
                self.overviewVC?.changed = true
                self.lastVC?.changed = true
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

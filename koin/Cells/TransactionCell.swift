//
//  TransactionCell.swift
//  koin
//
//  Created by Jaroslav Hampejs on 12/03/2021.
//

import Foundation
import UIKit

class TransactionCell: UICollectionViewCell {
    @IBOutlet weak var transactionTitle: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var counterparty: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialSetup()
    }
    
    func initialSetup() {
        clipsToBounds = true
        layer.masksToBounds = false
        layer.cornerRadius = 10
        
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath

        total.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .semibold)
    }
}

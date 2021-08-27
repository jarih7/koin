//
//  LastMonthView.swift
//  koin
//
//  Created by Jaroslav Hampejs on 16/03/2021.
//

import UIKit

class LastMonthView: UIControl {
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var monthInSymbol: UILabel!
    @IBOutlet weak var monthInSum: UILabel!
    @IBOutlet weak var monthOutSymbol: UILabel!
    @IBOutlet weak var monthOutSum: UILabel!
    @IBOutlet weak var monthBalance: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.masksToBounds = false
        layer.cornerRadius = 10
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.15
        
        monthInSum.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .semibold)
        monthOutSum.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .semibold)
        monthBalance.font = UIFont.monospacedSystemFont(ofSize: 30, weight: .bold)
    }
}

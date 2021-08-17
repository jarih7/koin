//
//  LastWeekView.swift
//  koin
//
//  Created by Jaroslav Hampejs on 16/03/2021.
//

import Foundation
import UIKit

class LastWeekView: UIControl {
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var weekInSymbol: UILabel!
    @IBOutlet weak var weekInSum: UILabel!
    @IBOutlet weak var weekOutSymbol: UILabel!
    @IBOutlet weak var weekOutSum: UILabel!
    @IBOutlet weak var weekBalance: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.masksToBounds = false
        layer.cornerRadius = 10
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.15
        
        weekInSum.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .semibold)
        weekOutSum.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .semibold)
        weekBalance.font = UIFont.monospacedSystemFont(ofSize: 30, weight: .bold)
    }
}

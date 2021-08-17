//
//  LastTransactionView.swift
//  koin
//
//  Created by Jaroslav Hampejs on 16/03/2021.
//

import Foundation
import UIKit

class LastTransactionView: UIControl {
    @IBOutlet weak var ltTitle: UILabel!
    @IBOutlet weak var ltTotal: UILabel!
    @IBOutlet weak var ltIncomingSymbol: UILabel!
    @IBOutlet weak var ltCounterparty: UILabel!
    @IBOutlet weak var ltDate: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.masksToBounds = false
        layer.cornerRadius = 10
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.15
        
        ltTotal.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .semibold)
    }
}

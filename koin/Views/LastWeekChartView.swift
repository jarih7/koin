//
//  LastWeekChartView.swift
//  koin
//
//  Created by Jaroslav Hampejs on 17/08/2021.
//

import Foundation
import UIKit

class LastWeekChartView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.15
    }
}

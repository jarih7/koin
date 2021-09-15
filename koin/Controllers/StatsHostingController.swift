//
//  SettingsHostingController.swift
//  koin
//
//  Created by Jaroslav Hampejs on 12/04/2021.
//

import UIKit
import SwiftUI

class StatsHostingController: UIHostingController<StatsView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: StatsView())
    }
}

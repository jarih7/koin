//
//  SettingsHostingController.swift
//  koin
//
//  Created by Jaroslav Hampejs on 12/04/2021.
//

import Foundation
import UIKit
import SwiftUI

class SettingsHostingController: UIHostingController<SettingsControllerSUI> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SettingsControllerSUI())
    }
}

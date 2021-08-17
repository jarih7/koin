//
//  TabBarController.swift
//  koin
//
//  Created by Jaroslav Hampejs on 12/03/2021.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

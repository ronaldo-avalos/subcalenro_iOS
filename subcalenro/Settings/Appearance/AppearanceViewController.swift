//
//  AppearanceViewController.swift
//  calenro
//
//  Created by ronaldo avalos on 12/09/24.
//

import Foundation
import UIKit

class AppearanceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Appearance"
        self.navigationController?.navigationBar.tintColor = ThemeManager.color(for: .primaryText)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
               NSAttributedString.Key.foregroundColor: ThemeManager.color(for: .primaryText)
           ]
        
    }
    
    
}

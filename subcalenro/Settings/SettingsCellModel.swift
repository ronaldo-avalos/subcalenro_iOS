//
//  SettingsCellModel.swift
//  subcalenro
//
//  Created by ronaldo avalos on 31/08/24.
//

import Foundation
import UIKit

struct SettingsCellModel {
    let type: SettingsCellType
    let title: String
    let iconImage: UIImage?
    let options: [String]?
    let selectedValue: String?
}

enum SettingsCellType {
    case withSwitch
    case withPopUp
    case withAccessory
}


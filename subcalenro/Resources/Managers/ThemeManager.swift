//
//  ThemeManager.swift
//  subcalenro
//
//  Created by ronaldo avalos on 28/09/24.
//

import Foundation
import UIKit

enum AppTheme: String {
    case system
    case retro
}

enum ThemeElement {
    case primaryBackground
    case secondaryBackground
    case primaryText
    case secondaryText
    case tableViewBacground
    case tableCellbackground
    case tableViewCellColor
    case editBackgroud
}

extension Notification.Name {
    static let themeChanged = Notification.Name("themeChanged")
}

class ThemeManager {
    
    static var currentTheme: AppTheme = loadSavedTheme() {
        didSet {
            NotificationCenter.default.post(name: .themeChanged, object: nil)
        }
    }
    
    static func saveThemeSelection(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: "appTheme")
    }
    
    
    static func loadSavedTheme() -> AppTheme {
        if let savedTheme = UserDefaults.standard.string(forKey: "appTheme") {
            return AppTheme(rawValue: savedTheme) ?? .system
        } else {
            return .system
        }
    }
    
    static func color(for element: ThemeElement) -> UIColor {
        switch currentTheme {
        case .system:
            return systemColors[element] ?? .black
        case .retro:
            return retroColors[element] ?? .blue
        }
    }

    // Colores por tema
    private static let retroColors: [ThemeElement: UIColor] = [
        .primaryBackground: .Retro.retroBeich ,
        .secondaryBackground: .Retro.retroTeal,
        .primaryText: .Retro.retroOrange,
        .secondaryText: .Retro.retroBeich,
        .tableViewBacground: .Retro.retroBeich
    ]
    

 private static let systemColors: [ThemeElement: UIColor] = [
    .primaryBackground: .DefaultTheme.principal,
    .secondaryBackground: .DefaultTheme.selection,
    .primaryText: .label,
    .secondaryText: .DefaultTheme.principal,
    .tableViewCellColor: .DefaultTheme.graycell,
    .editBackgroud: .DefaultTheme.editbackground
    ]

}

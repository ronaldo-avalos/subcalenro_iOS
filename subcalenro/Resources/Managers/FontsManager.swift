//
//  FontsManager.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 14/12/24.
//

import Foundation
import UIKit

extension UIFont.Weight {
    var fontName: String {
        switch self {
        case .ultraLight: return "UltraLight"
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "Semibold"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        case .black: return "Black"
        default: return "Regular"
        }
    }
}

struct FontManager {
    // Escala global para ajustar el tamaño de las fuentes
    static var fontScale: CGFloat = 1.0

    // MARK: - Obtener una fuente personalizada
    static func customFont(family: String, size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let adjustedSize = size * fontScale
        let fontName = "\(family)-\(weight.fontName)" // Ejemplo: "SF-Pro-Text-Regular"
        return UIFont(name: fontName, size: adjustedSize) ?? UIFont.systemFont(ofSize: adjustedSize, weight: weight)
    }

    // MARK: - Fuentes específicas
    static func sfCompactDisplay(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return customFont(family: "SF-Compact-Display", size: size, weight: weight)
    }

    static func sfProRounded(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return customFont(family: "SF-Pro-Rounded", size: size, weight: weight)
    }

    static func sfProText(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return customFont(family: "SF-Pro-Text", size: size, weight: weight)
    }

    static func sfProDisplay(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return customFont(family: "SF-Pro-Display", size: size, weight: weight)
    }

    static func playfairDisplay(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return customFont(family: "PlayfairDisplay", size: size, weight: weight)
    }

    // MARK: - Ajustar escala globalmente
    static func setFontScale(_ scale: CGFloat) {
        fontScale = scale
    }
}

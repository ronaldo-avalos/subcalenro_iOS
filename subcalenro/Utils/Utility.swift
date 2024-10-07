//
//  Utility.swift
//  subcalenro
//
//  Created by ronaldo avalos on 04/08/24.
//


import Foundation
import UIKit

class Utility {
    
    static func dateFormatter (date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    // MARK: - FunctionWithDelay
    static func executeFunctionWithDelay(delay: TimeInterval, function: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            function()
        }
    }

    
    // MARK: - FeedbackGenerator
    static func feedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    // MARK: - Device Info
    static let appVersion = "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown version")"
    static let deviceModel = UIDevice.current.model
    static let deviceName = UIDevice.current.systemName
    static let iOSVersion = UIDevice.current.systemVersion
    static let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    

    static func orientationDidChange() -> UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    static func isiPhoneProMax() -> Bool {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let isLandscape = UIDevice.current.orientation.isLandscape
        let isXSeries = (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) > 0

        let isiPhoneProMax = (isXSeries && max(screenWidth, screenHeight) > 852 && min(screenWidth, screenHeight) > 393 && isLandscape) || (!isLandscape && max(screenWidth, screenHeight) > 852 && min(screenWidth, screenHeight) > 393)
        return isiPhoneProMax
    }

    static func PrintFamiliesFont() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
   
    static func isIphoneWithSmallScreen() -> Bool {
        let screenSize = UIScreen.main.bounds.size
        let screenHeight = max(screenSize.width, screenSize.height)
        let screenWidth = min(screenSize.width, screenSize.height)
        
        let knownScreenSizes: [(width: CGFloat, height: CGFloat)] = [
            (320, 568),  // iPhone SE (1ª generación), iPhone 5, 5S, 5C
            (375, 667)   // iPhone 6, 6S, 7, 8, SE (2ª y 3ª generación)
        ]
        
        let isKnownSize = knownScreenSizes.contains { (width, height) in
            return width == screenWidth && height == screenHeight
        }
        
        return isKnownSize
    }

    
    // MARK: - Show Alerts
    static func showSimpleAlert(on viewController: UIViewController, title: String?, message: String, completion: @escaping () -> Void?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:  { _ in
            completion()
        }))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
    static func showInputAlert(on viewController: UIViewController, title: String, message: String?, completion: @escaping (String?) -> Void) {
          let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
          
        alertController.addTextField { textField in
              textField.clearButtonMode = .whileEditing
              textField.borderStyle = .none
          }
          
          alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
              let inputValue = alertController.textFields?.first?.text
              completion(inputValue)
          }))
          
          viewController.present(alertController, animated: true, completion: nil)
      }
    
    
    static func showDeleteConfirmationAlert(on viewController: UIViewController, title: String, message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title,
                                                message:message,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
        
    static func renderingIcon(_ nameIcon: String) -> UIImage {
        return UIImage(systemName: nameIcon)?.withTintColor(ThemeManager.color(for: .primaryText), renderingMode: .alwaysOriginal) ?? UIImage()
    }
    
    
}


//
//  PreferencesManager.swift
//  subcalenro
//
//  Created by ronaldo avalos on 24/06/24.
//

import Foundation
import UIKit

private let isProUserKey = "proAccount"
private let isFirstOpenKey = "isFirstOpen"
private let firstWeekdayKey = "firstWeekday"
private let lastInterstitialShownDateKey = "lastInterstitialShownDate"
private let showCollapsibleBannerAdKey = "showCollapsibleBannerAd"
private let showFreeWeekendsKey = "isFreeWeekends"
private let vibrationEnabledKey = "VibrationEnabled"
private let animationSelectDayKey = "animationSelectDay"

class PreferencesManager {
    
    static let shared = PreferencesManager()
    
    private let defaults : UserDefaults
    
    // MARK: - Initializer
    private init() {
        defaults = UserDefaults.standard
        firstWeekday = 2
    }
    
        var isProUser: Bool {
        get { return defaults.bool(forKey: isProUserKey) }
        set { defaults.setValue(newValue, forKey: isProUserKey) }
    }
    
    var isFirstOpen: Bool {
        get { return defaults.bool(forKey: isFirstOpenKey) }
        set { defaults.setValue(newValue, forKey: isFirstOpenKey) }
    }  
    
    var firstWeekday: Int {
        get {
            let storedValue = defaults.integer(forKey: firstWeekdayKey)
            return storedValue == 0 ? 2 : storedValue
        }
        set {
            defaults.setValue(newValue, forKey: firstWeekdayKey)
        }
    }
    
    var lastInterstitialShownDate: Date {
        get { return defaults.object(forKey: lastInterstitialShownDateKey) as? Date ?? Date.distantPast }
        set { defaults.setValue(newValue, forKey: lastInterstitialShownDateKey) }
    }
    
    var showFreeWeekends: Bool {
        get { return defaults.bool(forKey: showFreeWeekendsKey) }
        set { defaults.setValue(newValue, forKey: showFreeWeekendsKey) }
    }
    
    var vibrationEnabled: Bool {
        get { return defaults.bool(forKey: vibrationEnabledKey) }
        set { defaults.setValue(newValue, forKey: vibrationEnabledKey) }
    }
    
    var animationSelectDay: Bool {
        get { return defaults.bool(forKey: animationSelectDayKey) }
        set { defaults.setValue(newValue, forKey: animationSelectDayKey) }
    }
    
}

//
//  Subscription.swift
//  subcalenro
//
//  Created by ronaldo avalos on 06/10/24.
//

import Foundation

struct Subscription: Codable {
    let id: UUID
    let logoUrl: String
    var name: String
    var price: Double
    var nextPaymentDate: Date
    var period: SubscriptionPeriod
    var reminderTime: ReminderOption
    
    var hasReminder: Bool {
        return reminderTime != .none
    }
    
    var isExpired: Bool {
        return nextPaymentDate < Date()
    }
}

enum SubscriptionPeriod: Int, CaseIterable, Codable {
    case monthly = 1
    case yearly = 12
    case weekly = 7
    case biweekly = 14
    case custom = 0

    var name: String {
        switch self {
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        case .weekly:
            return "Weekly"
        case .biweekly:
            return "Biweekly"
        case .custom:
            return "Custom"
        }
    }
}


enum ReminderOption: Int, Codable, CaseIterable {
    case sameDay = 0
    case oneDayBefore = 1
    case threeDaysBefore = 3
    case oneWeekBefore = 7
    case none = -1

    var name: String {
        switch self {
        case .sameDay:
            return "Same Day"
        case .oneDayBefore:
            return "1 Day Before"
        case .threeDaysBefore:
            return "3 Days Before"
        case .oneWeekBefore:
            return "1 Week Before"
        case .none:
            return "None"
        }
    }
}


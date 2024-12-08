//
//  Subscription.swift
//  subcalenro
//
//  Created by ronaldo avalos on 06/10/24.
//

import Foundation

struct Subscription: Codable {
    let id: UUID
    var name: String
    var amount: Double
    let logoUrl: String
    var nextPaymentDate: Date
    var period: SubscriptionPeriod
    var reminderTime: ReminderOption
    var category: SubscriptionCategory
    var subscriptionType: SubscriptionType
    
    var hasReminder: Bool {
        return reminderTime != .none
    }
    
    var isExpired: Bool {
        return nextPaymentDate < Date()
    }
    
    var nextDateFomatter: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: nextPaymentDate)
    }

}

enum SubscriptionType: Int, CaseIterable , Codable {
    case trial = 1
    case recurring = 2
    case lifeTime = 3
    
    func displayName() -> String {
        switch self {
        case .trial:
            return "trial"
        case .recurring:
            return "recurring"
        case .lifeTime:
            return "lifeTime"
        }
        
    }
}

enum SubscriptionCategory: Int, CaseIterable, Codable {
    case other = 0
    case fitness = 1
    case hobby = 2
    case tools = 3
    case education = 4
    case entertainment = 5
    case productivity = 6
    case food = 7
    case transportation = 8
    case cloudStorage = 9
    case finance = 10
    case home = 11
    case gaming = 12
    case news = 13
    case beauty = 14
    case pets = 15
    case travel = 16
    case health = 17
    case sports = 18
    case socialMedia = 19
    
    func displayName() -> String {
        switch self {
        case .other:
            return "Other"
        case .fitness:
            return "Fitness"
        case .hobby:
            return "Hobby"
        case .tools:
            return "Tools"
        case .education:
            return "Education"
        case .entertainment:
            return "Entertainment"
        case .productivity:
            return "Productivity"
        case .food:
            return "Food"
        case .transportation:
            return "Transportation"
        case .cloudStorage:
            return "Cloud Storage"
        case .finance:
            return "Finance"
        case .home:
            return "Home"
        case .gaming:
            return "Gaming"
        case .news:
            return "News"
        case .beauty:
            return "Beauty"
        case .pets:
            return "Pets"
        case .travel:
            return "Travel"
        case .health:
            return "Health"
        case .sports:
            return "Sports"
        case .socialMedia:
            return "Social Media"
        }
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
    case twoDaysBefore = 2
    case threeDaysBefore = 3
    case fourDaysBefore = 4
    case fiveDaysBefore = 5
    case sixDaysBefore = 6
    case sevenDaysBefore = 7
    case none = -1

    var name: String {
        switch self {
        case .sameDay:
            return "Same Day"
        case .oneDayBefore:
            return "1 Day Before"
        case .twoDaysBefore:
            return "2 Days Before"
        case .threeDaysBefore:
            return "3 Days Before"
        case .fourDaysBefore:
            return "4 Days Before"
        case .fiveDaysBefore:
            return "5 Days Before"
        case .sixDaysBefore:
            return "6 Days Before"
        case .sevenDaysBefore:
            return "7 Days Before"
        case .none:
            return "None"
        }
    }
}








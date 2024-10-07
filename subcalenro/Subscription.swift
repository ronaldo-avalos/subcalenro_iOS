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
    var price: Double
    var nextPaymentDate: Date
    var period: SubscriptionPeriod
}

enum SubscriptionPeriod: String, CaseIterable, Codable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    case weekly = "Weekly"
    case biweekly = "Biweekly"
    case custom = "Custom"
}


//
//  SubscriptionsLoader.swift
//  subcalenro
//
//  Created by ronaldo avalos on 06/10/24.
//

import Foundation

class SubscriptionsLoader {
    
    static let shared = SubscriptionsLoader()
   
    func loadSubscriptionsDate() -> [(Date, Subscription)] {
        let subscriptions = SubscriptionManager.shared.readAllSubscriptions()
        let calendar = Calendar.current
        var eventDates: [(Date, Subscription)] = []
        for sub in subscriptions {
            var currentDate = sub.nextPaymentDate
            var intervalo : Calendar.Component = .month
            var days:Int = 1
            if let endDate = calendar.date(byAdding: .year, value: 2, to: currentDate) {
                while currentDate <= endDate {
                    eventDates.append((currentDate, sub))
                    switch sub.period {
                    case .monthly:
                        intervalo = .month
                        days = 1
                    case .yearly:
                        intervalo = .year
                        days = 1
                    case .weekly:
                        intervalo = .weekOfYear
                        days = 1
                    case .biweekly:
                        intervalo = .day
                        days = 14
                    case .custom:
                        intervalo = .day 
                    }
                    if let newDate = calendar.date(byAdding: intervalo, value: days, to: currentDate) {
                        currentDate = newDate
                    } else {
                        break
                    }
                }
            }
            
        }
        return eventDates
        
    }
}

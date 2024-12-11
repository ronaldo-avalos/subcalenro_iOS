//
//  NotificationManager.swift
//  subcalenro
//
//  Created by ronaldo avalos on 10/10/24.
//

import Foundation
import UserNotifications

enum PermissionType: String {
    case undefined
    case granted
    case denied
    case notNow
}

class NotificationManager {
    static let shared = NotificationManager()
    private var calendar = Calendar.current
    private let permissionKey = "notificationPermission"

    private init() {}
    
    func requestNotificationPermission(completion: @escaping (PermissionType) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
                self.savePermissionStatus(.denied)
                completion(.denied)
            } else {
                let status: PermissionType = granted ? .granted : .denied
                self.savePermissionStatus(status)
                completion(status) 
            }
        }
    }
    
    func savePermissionStatus(_ status: PermissionType) {
           UserDefaults.standard.set(status.rawValue, forKey: permissionKey)
       }
       
       func getPermissionStatus() -> PermissionType {
           let savedStatus = UserDefaults.standard.string(forKey: permissionKey) ?? PermissionType.undefined.rawValue
           return PermissionType(rawValue: savedStatus) ?? .undefined
       }
    
    // Programar las primeras 10 notificaciones para una suscripción
    func scheduleNotifications(for subscription: Subscription) {
        guard subscription.hasReminder, !subscription.isExpired else {
            print("No se puede programar la notificación porque la suscripción ha expirado o no tiene recordatorio")
            return
        }
        calendar.timeZone = TimeZone.current
        var nextPaymentDate = subscription.nextPaymentDate
        
        var notificationCounter = 0
        var notificationDates: [Date] = []
        let endDate = calendar.date(byAdding: .year, value: 2, to: nextPaymentDate) ?? Date()
        
        if calendar.startOfDay(for: nextPaymentDate) > calendar.startOfDay(for: Date()) {
            if let day = calendar.date(byAdding: .day, value: -1, to: nextPaymentDate) {
                var components = calendar.dateComponents([.year, .month, .day], from: day)
                components.hour = 12
                components.minute = 0
                
                if let nextDateAtNoon = calendar.date(from: components) {
                    self.scheduleNotification(nextDateAtNoon, subscription, notificationCounter: notificationCounter)
                }
            }
        }
        
        while calendar.startOfDay(for: nextPaymentDate) <= calendar.startOfDay(for: endDate) {
            nextPaymentDate = calculateNextPaymentDate(from: nextPaymentDate, period: subscription.period)
            let notificationDate = calendar.startOfDay(for: nextPaymentDate)
            
            if notificationDate >= calendar.startOfDay(for: Date()) {
                notificationDates.append(notificationDate)
                
                if let notificationTriggerDate = calendar.date(byAdding: .hour, value: -12, to: notificationDate) {
                    self.scheduleNotification(notificationTriggerDate, subscription, notificationCounter: notificationCounter)
                    if notificationCounter >= 20 {
                        break
                    }
                }
                
                notificationCounter += 1
            }
        }
    }
    
    // Programar notificación individual
    private func scheduleNotification(_ notificationTriggerDate: Date, _ sub: Subscription, notificationCounter: Int) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Recordatorio!"
        notificationContent.body = "Tienes un proximo pago de \(sub.name)"
        notificationContent.sound = .default
        
        let calendarComponents = calendar.dateComponents([.month, .day, .year, .hour, .minute, .second], from: notificationTriggerDate)
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: calendarComponents, repeats: false)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        let formattedDate = dateFormatter.string(from: notificationTriggerDate)
        
        // Asegurar un identificador único usando el contador
        let notificationRequest = UNNotificationRequest(identifier: "\(sub.id)_\(formattedDate)_\(notificationCounter)", content: notificationContent, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { error in
            guard error == nil else {
                 print("Error Notification schedule \(String(describing: error))")
                return
            }
            print("Notification scheduled for \(sub.name) on date = \(notificationTriggerDate)")
        }
    }
    
    // Calcular la siguiente fecha de pago según el periodo de la suscripción
    private func calculateNextPaymentDate(from currentPaymentDate: Date, period: SubscriptionPeriod) -> Date {
        let calendar = Calendar.current
        
        switch period {
        case .monthly:
            return calendar.date(byAdding: .month, value: 1, to: currentPaymentDate) ?? currentPaymentDate
        case .yearly:
            return calendar.date(byAdding: .year, value: 1, to: currentPaymentDate) ?? currentPaymentDate
        case .weekly:
            return calendar.date(byAdding: .day, value: 7, to: currentPaymentDate) ?? currentPaymentDate
        case .biweekly:
            return calendar.date(byAdding: .day, value: 14, to: currentPaymentDate) ?? currentPaymentDate

        }
    }
    
    // Cancelar notificaciones para una suscripción específica
    func cancelNotifications(for subscription: Subscription) {
        // Elimina las notificaciones utilizando un patrón que incluya el ID de la suscripción
        let identifiers = (0...20).map { "\(subscription.id)_\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        print("Notificaciones canceladas para \(subscription.name)")
    }
}

//
//  NotificationManager.swift
//  subcalenro
//
//  Created by ronaldo avalos on 10/10/24.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}

    // Solicitar permisos para enviar notificaciones
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    // Programar las primeras 10 notificaciones para una suscripción
    func scheduleFirstTenNotifications(for subscription: Subscription) {
        guard subscription.hasReminder, !subscription.isExpired else {
            print("No se puede programar la notificación porque la suscripción ha expirado o no tiene recordatorio")
            return
        }
        
        var nextPaymentDate = subscription.nextPaymentDate
        
        // Programar las primeras 10 notificaciones
        for i in 1...10 {
            guard let triggerDateComponents = calculateTriggerDate(for: subscription, nextPaymentDate: nextPaymentDate) else {
                print("No se pudo calcular la fecha de activación de la notificación para el ciclo \(i)")
                continue
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Recordatorio"
            content.body = "El siguiente pago de \(subscription.name) es pronto."
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            
            // Crear una solicitud de notificación con identificador único para cada ciclo
            let request = UNNotificationRequest(identifier: "\(subscription.id.uuidString)_\(i)", content: content, trigger: trigger)
            
            // Añadir la notificación
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error al programar la notificación \(i): \(error.localizedDescription)")
                } else {
                    print("Notificación \(i) programada para \(subscription.name)")
                }
            }
            
            // Calcular la siguiente fecha de pago en función del periodo
            nextPaymentDate = calculateNextPaymentDate(from: nextPaymentDate, period: subscription.period)
        }
    }
    
    // Calcular la fecha de activación de la notificación
    private func calculateTriggerDate(for subscription: Subscription, nextPaymentDate: Date) -> DateComponents? {
        let calendar = Calendar.current
        
        // Restar los días seleccionados (reminderTime) de la fecha del siguiente pago
        var reminderDate: Date?
        
        switch subscription.reminderTime {
        case .sameDay:
            reminderDate = nextPaymentDate
        case .oneDayBefore:
            reminderDate = calendar.date(byAdding: .day, value: -1, to: nextPaymentDate)
        case .threeDaysBefore:
            reminderDate = calendar.date(byAdding: .day, value: -3, to: nextPaymentDate)
        case .oneWeekBefore:
            reminderDate = calendar.date(byAdding: .day, value: -7, to: nextPaymentDate)
        case .none:
            return nil
        }
        
        guard let finalReminderDate = reminderDate else {
            return nil
        }
        
        // Crear los componentes de fecha necesarios para el trigger
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: finalReminderDate)
        
        return components
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
        case .custom:
            // Definir la lógica personalizada según las reglas de tu aplicación
            return currentPaymentDate
        }
    }
    
    // Cancelar notificaciones para una suscripción específica
    func cancelNotifications(for subscription: Subscription) {
        let identifiers = (1...10).map { "\(subscription.id.uuidString)_\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        print("Notificaciones canceladas para \(subscription.name)")
    }
}

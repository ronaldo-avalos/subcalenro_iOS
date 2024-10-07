//
//  subscriptionsDataSource.swift
//  subcalenro
//
//  Created by ronaldo avalos on 05/10/24.
//

import Foundation

class SubscriptionManager {
    static let shared = SubscriptionManager()
    private let fileName = "subscriptions.json"
    
    
    // Ruta del archivo
    private var fileURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName)
    }
    
    // Guardar una suscripción
    func save(_ subscription: Subscription) {
        var subscriptions = readAllSubscriptions() // Leer todas las suscripciones
        subscriptions.append(subscription) // Agregar la nueva
        saveToDisk(subscriptions) // Guardar la lista actualizada
        print("Subscription saved: \(subscription)")

    }
    
    // Leer todas las suscripciones
    func readAllSubscriptions() -> [Subscription] {
        guard let data = try? Data(contentsOf: fileURL) else {
            return []
        }
        
        let subscriptions = try? JSONDecoder().decode([Subscription].self, from: data)
        return subscriptions ?? []
    }
    
    // Leer una suscripción por ID
    func readById(_ id: UUID) -> Subscription? {
        let subscriptions = readAllSubscriptions()
        return subscriptions.first { $0.id == id }
    }
    
    func readByIds(_ ids: [UUID]) -> [Subscription] {
        let subscriptions = readAllSubscriptions()
          return subscriptions.filter { ids.contains($0.id) }
      }
      
    
    // Eliminar una suscripción por ID
    func deleteById(_ id: UUID) {
        var subscriptions = readAllSubscriptions()
        subscriptions.removeAll { $0.id == id }
        saveToDisk(subscriptions)
    }
    
    // Guardar la lista actualizada de suscripciones en el archivo
    private func saveToDisk(_ subscriptions: [Subscription]) {
        let data = try? JSONEncoder().encode(subscriptions)
        try? data?.write(to: fileURL)
    }
}




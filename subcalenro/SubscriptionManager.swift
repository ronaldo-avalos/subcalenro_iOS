//
//  subscriptionsDataSource.swift
//  subcalenro
//
//  Created by ronaldo avalos on 05/10/24.
//

import Foundation

struct SubscriptionManager {
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
    
    func getSubscriptionTotal () -> Int {
        return readAllSubscriptions().count
    }

    func getSubscriptionTotalsByCategory() -> [String: Double] {
        // Leer todas las suscripciones
        let subscriptions = readAllSubscriptions()
        
        // Diccionario para acumular los montos por categoría
        var categoryTotals: [String: Double] = [:]
        
        // Iterar sobre cada suscripción
        for subscription in subscriptions {
            let category = subscription.category.displayName() // Obtenemos la categoría de la suscripción
            let amount = subscription.amount     // Obtenemos el monto de la suscripción
            
            // Si la categoría ya existe, sumamos el monto; si no, la creamos con el monto inicial
            if let total = categoryTotals[category] { // Accedemos usando un String como clave
                categoryTotals[category] = total + amount // Sumamos si ya existe
            } else {
                categoryTotals[category] = amount // Asignamos el valor si no existe
            }
        }
        
        return categoryTotals // Devolvemos el diccionario con los totales por categoría
    }


}




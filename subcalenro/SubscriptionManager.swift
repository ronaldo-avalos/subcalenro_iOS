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

    func getSubscriptionCountByCategory() -> [String: Int] {
        // Leer todas las suscripciones
        let subscriptions = readAllSubscriptions()
        
        // Diccionario para contar las suscripciones por categoría
        var categoryCounts: [String: Int] = [:]
        
        // Iterar sobre cada suscripción
        for subscription in subscriptions {
            let category = subscription.category.displayName() // Obtenemos la categoría de la suscripción
            
            // Si la categoría ya existe, sumamos 1; si no, la creamos con el valor inicial de 1
            if let count = categoryCounts[category] {
                categoryCounts[category] = count + 1 // Incrementamos el conteo
            } else {
                categoryCounts[category] = 1 // Asignamos el valor inicial si no existe
            }
        }
        
        return categoryCounts // Devolvemos el diccionario con los conteos por categoría
    }

    func getSubscriptions(for category: String) -> [Subscription] {
          let allSubscriptions = readAllSubscriptions()
        let filteredSubscriptions = allSubscriptions.filter { $0.category.displayName() == category }
          return filteredSubscriptions
      }
      
  
    func getConstTotal() ->  Double {
        let allSubscriptions = readAllSubscriptions()
        var total : Double = 0.0
        for subscription in allSubscriptions {
            let amount = subscription.amount
            total = amount + total
        }
        return total
    }
      

}




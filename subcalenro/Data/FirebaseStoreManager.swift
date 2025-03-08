//
//  FirebaseStoreManager.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 12/12/24.
//

import Foundation
import FirebaseFirestore


struct FirebaseStoreManager {
    
    func fetchSubscriptions(completion: @escaping ([Company]) -> Void) {
        let db = Firestore.firestore()
        db.collection("Subscriptions").getDocuments { snapshot, error in
            if let error = error {
                print("Error al obtener suscripciones: \(error.localizedDescription)")
                completion([])
            } else if let snapshot = snapshot {
                let subscriptions: [Company] = snapshot.documents.compactMap { doc in
                    return Company(dictionary: doc.data(), id: doc.documentID)
                }
                completion(subscriptions)
            }
        }
    }
}

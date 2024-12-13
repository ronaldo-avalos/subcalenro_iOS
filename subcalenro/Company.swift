//
//  Company.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 12/12/24.
//

import Foundation
struct Company {
    let id: String
    let name: String
    let category: String
    let imageUrl: String

    // Inicializador desde un diccionario
    init?(dictionary: [String: Any], id: String) {
        guard let name = dictionary["name"] as? String,
              let category = dictionary["categorie"] as? String,
              let imageUrl = dictionary["imageUrl"] as? String else { return nil }
        self.id = id
        self.name = name
        self.category = category
        self.imageUrl = imageUrl
    }
}

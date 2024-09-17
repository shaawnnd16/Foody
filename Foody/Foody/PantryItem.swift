//
//  PantryItem.swift
//  Foody
//
//  Created by Shawn De Alwis on 18/9/2024.
//

import Foundation

class PantryItem: Identifiable {
    let id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

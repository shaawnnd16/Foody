//
//  FoodyApp.swift
//  Foody
//
//  Created by Shawn De Alwis on 18/9/2024.
//

import SwiftUI

@main
struct CookingApp: App {
    @StateObject private var pantryManager = PantryManager()
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environmentObject(pantryManager) // Inject PantryManager into the environment
        }
    }
}

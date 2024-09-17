//
//  TabBarView.swift
//  Foody
//
//  Created by Shawn De Alwis on 18/9/2024.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var pantryManager: PantryManager

    var body: some View {
        TabView {
            ContentView() // Home view with recipes
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            LikedRecipesView() // View showing liked recipes
                .tabItem {
                    Label("Liked", systemImage: "heart")
                }
        }
    }
}

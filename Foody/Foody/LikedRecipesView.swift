//
//  LikedRecipesView.swift
//  Foody
//
//  Created by Shawn De Alwis on 18/9/2024.
//

import SwiftUI

struct LikedRecipesView: View {
    @EnvironmentObject var pantryManager: PantryManager

    var body: some View {
        NavigationView {
            List {
                if pantryManager.likedRecipes.isEmpty {
                    Text("No liked recipes yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(pantryManager.likedRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipeID: recipe.id).environmentObject(pantryManager)) {
                            Text(recipe.name)
                        }
                    }
                }
            }
            .navigationTitle("Liked Recipes")
        }
    }
}

//
//  RecipeDetailView.swift
//  Foody
//
//  Created by Shawn De Alwis on 18/9/2024.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipeID: Int // Expecting an Int

    @EnvironmentObject var pantryManager: PantryManager // Access pantryManager
    @State private var recipe: DetailedRecipe? // To store the detailed recipe

    var body: some View {
        ScrollView {
            if let recipe = recipe {
                // Display the recipe details
                Text(recipe.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                // Other UI components...
                Text("Ingredients:")
                ForEach(recipe.extendedIngredients, id: \.id) { ingredient in
                    Text("\(ingredient.name): \(ingredient.amount, specifier: "%.2f") \(ingredient.unit)")
                }

                Text("Instructions:")
                Text(recipe.instructions.stripHTML())
            } else {
                Text("Loading...")
                    .onAppear {
                        fetchRecipeDetails() // Fetch details when the view appears
                    }
            }
        }
        .navigationTitle("Recipe Details")
    }

    private func fetchRecipeDetails() {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/\(recipeID)/information?apiKey=\(pantryManager.apiKey)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching recipe details: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let detailedRecipe = try JSONDecoder().decode(DetailedRecipe.self, from: data)
                DispatchQueue.main.async {
                    self.recipe = detailedRecipe
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }
}

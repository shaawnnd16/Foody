//
//  PantryManager.swift
//  Foody
//
//  Created by Shawn De Alwis on 18/9/2024.
//

import Foundation
import SwiftUI

class PantryManager: ObservableObject {
    @Published private(set) var pantryItems: [PantryItem] = [] // Pantry items
    @Published private(set) var suggestedRecipes: [Recipe] = [] // Suggested recipes from API
    @Published private(set) var likedRecipes: [Recipe] = [] // Liked recipes
    @Published var selectedRecipe: DetailedRecipe? // Store selected recipe details
    
    let apiKey = "a4c7f1c770064915bc096afebbecf6ae" // Replace with your actual API key
    
    // Add a pantry item
    func addPantryItem(_ item: PantryItem) {
        pantryItems.append(item)
    }
    
    // Remove a pantry item
    func removePantryItem(_ item: PantryItem) {
        if let index = pantryItems.firstIndex(where: { $0.id == item.id }) {
            pantryItems.remove(at: index)
        }
    }
    
    // Like a recipe
    func likeRecipe(id: Int) {
        if let index = likedRecipes.firstIndex(where: { $0.id == id }) {
            // Recipe is already liked, so remove it (dislike)
            likedRecipes.remove(at: index)
            
            // Update the suggestedRecipes to set isLiked to false
            if let suggestedIndex = suggestedRecipes.firstIndex(where: { $0.id == id }) {
                var recipeToUpdate = suggestedRecipes[suggestedIndex]
                recipeToUpdate.isLiked = false
                suggestedRecipes[suggestedIndex] = recipeToUpdate // Update the array
            }
        } else {
            // Recipe is not liked, so add it (like)
            if let suggestedIndex = suggestedRecipes.firstIndex(where: { $0.id == id }) {
                var recipeToLike = suggestedRecipes[suggestedIndex]
                recipeToLike.isLiked = true
                likedRecipes.append(recipeToLike) // Add to liked recipes
                suggestedRecipes[suggestedIndex] = recipeToLike // Update the array
            }
        }
    }
    
    // Fetch recipes based on pantry items and filters
    func fetchRecipes(diet: String, mealType: String, cuisine: String) {
        let ingredients = pantryItems.map { $0.name }.joined(separator: ",")
        
        var urlString = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(ingredients)&number=5&apiKey=\(apiKey)"
        
        // Use 'complexSearch' if filters are applied
        if !diet.isEmpty || !mealType.isEmpty || !cuisine.isEmpty {
            urlString = "https://api.spoonacular.com/recipes/complexSearch?number=5&apiKey=\(apiKey)"
            if !diet.isEmpty {
                urlString += "&diet=\(diet.lowercased())"
            }
            if !mealType.isEmpty {
                urlString += "&type=\(mealType.lowercased())"
            }
            if !cuisine.isEmpty {
                urlString += "&cuisine=\(cuisine.lowercased())"
            }
        }
        
        print("Fetching recipes with URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching recipes: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                if diet.isEmpty && mealType.isEmpty && cuisine.isEmpty {
                    // Use findByIngredients response structure
                    let recipeData = try JSONDecoder().decode([APIRecipe].self, from: data)
                    DispatchQueue.main.async {
                        self.suggestedRecipes = recipeData.map { apiRecipe in
                            Recipe(id: apiRecipe.id, name: apiRecipe.title, ingredients: apiRecipe.usedIngredients.map { $0.name }, isLiked: false) // Set isLiked to false
                        }
                    }
                } else {
                    // Use complexSearch response structure
                    let complexRecipeData = try JSONDecoder().decode(ComplexSearchResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.suggestedRecipes = complexRecipeData.results.map { complexRecipe in
                            Recipe(id: complexRecipe.id, name: complexRecipe.title, ingredients: [], isLiked: false) // Set isLiked to false
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }
    
    // Fetch detailed recipe information
    func fetchRecipeDetails(for recipeID: Int) {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/\(recipeID)/information?apiKey=\(apiKey)") else {
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
                    self.selectedRecipe = detailedRecipe
                    print("Selected recipe: \(String(describing: self.selectedRecipe))") // Debugging
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }
}

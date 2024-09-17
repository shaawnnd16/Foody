//
//  RecipeModels.swift
//  Foody
//
//  Created by Shawn De Alwis on 18/9/2024.
//

import Foundation

// Struct for the complexSearch API response
struct ComplexSearchResponse: Codable {
    let results: [ComplexRecipe]
}

struct ComplexRecipe: Codable {
    let id: Int
    let title: String
}

// Detailed recipe model for showing recipe details
struct DetailedRecipe: Codable, Identifiable {
    let id: Int
    let title: String
    let summary: String
    let instructions: String
    let extendedIngredients: [DetailedIngredient] // Ingredients array

    // Computed property to return clean summary
    var cleanSummary: String {
        return summary.stripHTML()
    }

    // Computed property to return clean instructions
    var cleanInstructions: String {
        return instructions.stripHTML()
    }
}

// Ingredient model for the detailed recipe
struct DetailedIngredient: Codable, Identifiable {
    let id: Int // Ensure that the ingredient has a unique id
    let name: String
    let amount: Double
    let unit: String
}

// Struct for recipes used in the application
struct Recipe: Identifiable {
    let id: Int
    var name: String
    var ingredients: [String]
    var isLiked: Bool // Track if the recipe is liked
}



// Struct for the API response from findByIngredients
struct APIRecipe: Codable {
    let id: Int
    let title: String
    let usedIngredients: [APIIngredient] // Ingredients available in the pantry
}

// Ingredient model in the API response (used in APIRecipe)
struct APIIngredient: Codable {
    let name: String
}

// String extension to strip HTML from text
extension String {
    func stripHTML() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        } else {
            return self
        }
    }
}

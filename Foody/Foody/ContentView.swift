//
//  ContentView.swift
//  Foody
//
//  Created by Shawn De Alwis on 18/9/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pantryManager: PantryManager
    @State private var itemName = "" // Only track the item name
    @State private var showingDetail = false // Track detail view
    @State private var selectedRecipeID: Int? // Track the selected recipe ID
    
    // Filters
    @State private var selectedDiet = "None"
    @State private var selectedMealType = "None"
    @State private var selectedCuisine = "None"
    
    let dietOptions = ["None", "Vegetarian", "Vegan", "Gluten Free", "Ketogenic", "Paleo"]
    let mealTypeOptions = ["None", "Breakfast", "Lunch", "Dinner", "Snack"]
    let cuisineOptions = ["None", "Italian", "Mexican", "Chinese", "American", "Indian"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Add pantry item section
                HStack {
                    TextField("Enter item name", text: $itemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add Item") {
                        addItem()
                    }
                }
                .padding()
                
                // Filters
                VStack(alignment: .leading, spacing: 10) {
                    Text("Diet")
                    Picker("Select Diet", selection: $selectedDiet) {
                        ForEach(dietOptions, id: \.self) { diet in
                            Text(diet)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("Meal Type")
                    Picker("Select Meal Type", selection: $selectedMealType) {
                        ForEach(mealTypeOptions, id: \.self) { mealType in
                            Text(mealType)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("Cuisine")
                    Picker("Select Cuisine", selection: $selectedCuisine) {
                        ForEach(cuisineOptions, id: \.self) { cuisine in
                            Text(cuisine)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                
                // Display pantry items and recipes
                List {
                    Section(header: Text("Pantry Items")) {
                        ForEach(pantryManager.pantryItems) { item in
                            Text(item.name)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    
                    // Display recipe suggestions
                    Section(header: Text("Recipe Suggestions")) {
                        ForEach(pantryManager.suggestedRecipes) { recipe in
                            HStack {
                                Button(action: {
                                    selectedRecipeID = recipe.id // Set the selected recipe ID
                                    showingDetail.toggle() // Show the detail view
                                }) {
                                    Text(recipe.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Button(action: {
                                    pantryManager.likeRecipe(id: recipe.id)
                                }) {
                                    Image(systemName: recipe.isLiked ? "heart.fill" : "heart")
                                        .foregroundColor(recipe.isLiked ? .red : .gray)
                                }
                                .buttonStyle(PlainButtonStyle()) // Prevent the button from expanding
                            }
                        }
                    }
                }
                
                Button("Fetch Recipes") {
                    fetchRecipesWithFilters()
                }
                .padding()
            }
            .navigationTitle("Pantry Manager")
            .toolbar {
                EditButton()
            }
            .sheet(isPresented: $showingDetail) {
                if let selectedRecipeID = selectedRecipeID {
                    RecipeDetailView(recipeID: selectedRecipeID) // Pass the ID instead of the whole recipe
                        .environmentObject(pantryManager) // Pass the pantryManager if needed
                }
            }
        }
    }
    
    // Function to add a pantry item without quantity
    func addItem() {
        let trimmedItemName = itemName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !trimmedItemName.isEmpty {
            let item = PantryItem(name: trimmedItemName)
            pantryManager.addPantryItem(item)
            itemName = "" // Clear the input after adding the item
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = pantryManager.pantryItems[index]
            pantryManager.removePantryItem(item)
        }
    }
    
    // Fetch recipes based on filters
    func fetchRecipesWithFilters() {
        pantryManager.fetchRecipes(
            diet: selectedDiet != "None" ? selectedDiet : "",
            mealType: selectedMealType != "None" ? selectedMealType : "",
            cuisine: selectedCuisine != "None" ? selectedCuisine : ""
        )
    }
}

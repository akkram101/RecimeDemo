//
//  MockRecipeFilterSimulator.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import Foundation

///Simulate backend filtering
final class MockRecipeFilterSimulator {
    static func applyFilter(
        _ filter: RecipeFilter,
        to recipes: [Recipe],
        ingredientLookup: [String: Ingredient],
        dietLookup: [String: DietaryAttribute]
    ) -> [Recipe] {
        recipes.filter { recipe in
            
            // Servings
            if let servings = filter.servings {
                if recipe.servings != servings {
                    return false
                }
            }

            
            // Dietary attributes
            if let dietaryAttributes = filter.dietaryAttributes, !dietaryAttributes.isEmpty {
                let recipeAttributes = Set(recipe.dietaryAttributes)
                let requiredAttributes = Set(dietaryAttributes.compactMap { $0.id })
                if !requiredAttributes.isSubset(of: recipeAttributes) {
                    return false
                }
            }
            
            // Include ingredients
            if let includeIngredients = filter.includeIngredients, !includeIngredients.isEmpty {
                let recipeIngredientIds = Set(recipe.ingredients.compactMap { $0.ingredientId })
                let requiredIngredientIds = Set(includeIngredients.compactMap { $0.ingredientId })
                if !requiredIngredientIds.isSubset(of: recipeIngredientIds) {
                    return false
                }
            }
            
            // Exclude ingredients
            if let excludeIngredients = filter.excludeIngredients, !excludeIngredients.isEmpty {
                let recipeIngredientIds = Set(recipe.ingredients.compactMap { $0.ingredientId })
                let excludedIngredientIds = Set(excludeIngredients.compactMap { $0.ingredientId })
                if !recipeIngredientIds.isDisjoint(with: excludedIngredientIds) {
                    return false
                }
            }
            
            // Text search
            if let searchText = filter.searchText, !searchText.isEmpty {
                let lowerSearch = searchText.lowercased()
                
                // Title / description
                if recipe.title.lowercased().contains(lowerSearch) { return true }
                if recipe.recipeDescription.lowercased().contains(lowerSearch) == true { return true }
                
                // Ingredient names
                for ing in recipe.ingredients {
                    if let id = ing.ingredientId,
                       let ing = ingredientLookup[String(describing: id)],
                       let ingName = ing.name,
                       ingName.lowercased().contains(lowerSearch) {
                        return true
                    }
                }
                
                // Diet names
                for dietId in recipe.dietaryAttributes {
                    if let diet = dietLookup[String(describing: dietId)] {
                        if diet.name.lowercased().contains(lowerSearch) {
                             return true
                        }
                    }
                }
                
                // If nothing matched, reject
                return false
            }

            
            return true
        }
    }
}


//
//  RecipeFilter.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/19/26.
//

import Foundation

enum RecipeFilterOption: String, CaseIterable {
    case diet
    case ingredients
    case servings
    
    var title: String {
        switch self {
        case .diet: "Diet"
        case .ingredients: "Ingredients"
        case .servings: "Servings"
        }
    }
}

// MARK: - RecipeFilter Core
struct RecipeFilter {
    // MARK: - Filters
    /// Optional search string
    var searchText: String? = nil
    
    /// Optional servings filter (e.g. exact match or minimum)
    var servings: Int? = nil
    
    /// Dietary attributes to filter by (e.g. gluten-free, keto)
    var dietaryAttributes: [DietaryAttribute]? = nil
    
    /// Ingredients that must be included
    var includeIngredients: [Ingredient]? = nil
    
    /// Ingredients that must be excluded
    var excludeIngredients: [Ingredient]? = nil
}

// MARK: - Equality 
extension RecipeFilter {
    /// Compares two filters by value in a stable way (IDs & scalar values),
    /// ignoring ordering of selected items.
    func isEquivalent(to other: RecipeFilter) -> Bool {
        if searchText != other.searchText { return false }
        if servings != other.servings { return false }

        let dietsA = Set((dietaryAttributes ?? []).compactMap(\.id))
        let dietsB = Set((other.dietaryAttributes ?? []).compactMap(\.id))
        if dietsA != dietsB { return false }

        let includeA = Set((includeIngredients ?? []).compactMap(\.ingredientId))
        let includeB = Set((other.includeIngredients ?? []).compactMap(\.ingredientId))
        if includeA != includeB { return false }

        let excludeA = Set((excludeIngredients ?? []).compactMap(\.ingredientId))
        let excludeB = Set((other.excludeIngredients ?? []).compactMap(\.ingredientId))
        if excludeA != excludeB { return false }

        return true
    }
}

// MARK: - Dietary Attribute Helpers
extension RecipeFilter {
    mutating func addDietaryAttribute(_ diet: DietaryAttribute) {
        if dietaryAttributes == nil { dietaryAttributes = [] }
        
        guard !(dietaryAttributes?.contains(where: { $0.id == diet.id }) ?? false) else {
            return
        }
        
        dietaryAttributes?.append(diet)
    }
    
    mutating func removeDietaryAttribute(_ diet: DietaryAttribute) {
        dietaryAttributes?.removeAll { $0.id == diet.id }
    }
    
    func isDietSelected(_ diet: DietaryAttribute) -> Bool {
        dietaryAttributes?.contains(where: { $0.id == diet.id }) ?? false
    }
}

// MARK: - Ingredient Helpers
extension RecipeFilter {
    mutating func addIncludeIngredient(_ ingredient: Ingredient) {
        // Remove from excluded if present
        excludeIngredients?.removeAll { $0.ingredientId == ingredient.ingredientId }
        
        if includeIngredients == nil { includeIngredients = [] }
        
        guard !(includeIngredients?.contains(where: { $0.ingredientId == ingredient.ingredientId }) ?? false) else {
            return
        }
        
        includeIngredients?.append(ingredient)
    }
    
    mutating func removeIncludeIngredient(_ ingredient: Ingredient) {
        includeIngredients?.removeAll { $0.ingredientId == ingredient.ingredientId }
    }
    
    mutating func addExcludeIngredient(_ ingredient: Ingredient) {
        // Remove from included if present
        includeIngredients?.removeAll { $0.ingredientId == ingredient.ingredientId }
        
        if excludeIngredients == nil { excludeIngredients = [] }
        
        guard !(excludeIngredients?.contains(where: { $0.ingredientId == ingredient.ingredientId }) ?? false) else {
            return
        }
        
        excludeIngredients?.append(ingredient)
    }
    
    mutating func removeExcludeIngredient(_ ingredient: Ingredient) {
        excludeIngredients?.removeAll { $0.ingredientId == ingredient.ingredientId }
    }
    
    func isIngredientIncluded(_ ingredient: Ingredient) -> Bool {
        includeIngredients?.contains(where: { $0.ingredientId == ingredient.ingredientId }) ?? false
    }
    
    func isIngredientExcluded(_ ingredient: Ingredient) -> Bool {
        excludeIngredients?.contains(where: { $0.ingredientId == ingredient.ingredientId }) ?? false
    }
}

// MARK: - Servings Helpers
extension RecipeFilter {
    mutating func setServings(_ value: Int?) {
        servings = value
    }
    
    mutating func clearServings() {
        servings = nil
    }
}

// MARK: - Utility Helpers
extension RecipeFilter {
    /// Reset all filters
    mutating func reset() {
        servings = nil
        dietaryAttributes = nil
        includeIngredients = nil
        excludeIngredients = nil
    }
    
    /// Check if no filters are applied
    var isEmpty: Bool {
        servings == nil &&
        (dietaryAttributes?.isEmpty ?? true) &&
        (includeIngredients?.isEmpty ?? true) &&
        (excludeIngredients?.isEmpty ?? true)
    }
    
    /// Check if servings filter is applied
    var hasServingsFilter: Bool {
        servings != nil
    }
    
    /// Check if diet filter is applied
    var hasDietFilter: Bool {
        !(dietaryAttributes?.isEmpty ?? true)
    }
    
    /// Check if ingredient filter is applied
    var hasIngredientFilter: Bool {
        !(includeIngredients?.isEmpty ?? true) || !(excludeIngredients?.isEmpty ?? true)
    }
    
    /// Count how many filters are currently applied
    var filterCount: Int {
        var count = 0
        
        if servings != nil {
            count += 1
        }
        count += dietaryAttributes?.count ?? 0
        count += includeIngredients?.count ?? 0
        count += excludeIngredients?.count ?? 0
        
        return count
    }
}

//MARK: Network Helper
extension RecipeFilter {
    func toParameters() -> [String: Any] {
        var params: [String: Any] = [:]
        
        if let servings = servings {
            params["servings"] = servings
        }
        
        if let dietaryAttributes = dietaryAttributes, !dietaryAttributes.isEmpty {
            params["dietaryAttributes"] = dietaryAttributes.map { $0.id }
        }
        
        if let includeIngredients = includeIngredients, !includeIngredients.isEmpty {
            params["includeIngredients"] = includeIngredients.map { $0.ingredientId }
        }
        
        if let excludeIngredients = excludeIngredients, !excludeIngredients.isEmpty {
            params["excludeIngredients"] = excludeIngredients.map { $0.ingredientId }
        }
        
        return params
    }
}

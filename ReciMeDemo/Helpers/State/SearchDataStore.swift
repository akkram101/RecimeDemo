//
//  SearchDataStore.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import Foundation
import SwiftUI

enum SuggestionCategory: String {
    case text
    case ingredient
    case diet
    case custom
}

struct Suggestion: Identifiable {
    var id: String = UUID().uuidString
    var ingredientId: String? = nil
    var dietId: String? = nil
    let category: SuggestionCategory
    let title: String
    let description: String?
}


///Acts as mock data base
struct SearchDataStore {
    static var ingredientDictionary: [String: Ingredient] = [:]
    static var dietDictionary: [String: DietaryAttribute] = [:]
    
    /// Ordered list of recent searches.
    /// The most recently searched term is appended at the end.
    static var recentSearches: [String] = ["Egg" , "Garlic", "Vegetarian", "Keto", "Butter"]
    static var suggestions: [Suggestion] = []
}

extension SearchDataStore {
    static func registerRecentSearches() {
        suggestions.removeAll { $0.category == .text }
        
        let recents = recentSearches.map {
            Suggestion(category: .text, title: $0, description: nil)
        }
        suggestions.append(contentsOf: recents)
    }

    static func registerIngredients(_ ingredients: [Ingredient]) {
        suggestions.removeAll { $0.category == .ingredient }
        
        for ing in ingredients {
            if let id = ing.ingredientId {
                ingredientDictionary["\(id)"] = ing
            }
        }
        
        let ingSuggestions: [Suggestion] = ingredients.compactMap { ing in
            if let id = ing.ingredientId {
                return Suggestion(
                    ingredientId: "\(id)",
                    category: .ingredient,
                    title: ing.name ?? "",
                    description: nil
                )
            }
            return nil
        }
        
        suggestions.append(contentsOf: ingSuggestions)
    }

    static func registerDiets(_ diets: [DietaryAttribute]) {
        suggestions.removeAll { $0.category == .diet }
        for diet in diets {
            if let id = diet.id {
                dietDictionary["\(id)"] = diet
            }
        }
        
        let dietSuggestions: [Suggestion] = diets.compactMap { diet in
            if let id = diet.id {
                return Suggestion(
                    dietId: "\(id)",
                    category: .diet,
                    title: diet.name,
                    description: nil
                )
            }
            return nil
        }
        
        suggestions.append(contentsOf: dietSuggestions)
    }
    
    static func registerNewSuggestion(_ suggestion: Suggestion) {
        suggestions.append(suggestion)

        switch suggestion.category {
        case .text: break
        case .ingredient:
            if let ingId = suggestion.ingredientId {
                ingredientDictionary[ingId] = Ingredient(
                    ingredientId: Int(ingId),
                    name: suggestion.title
                )
            }

        case .diet:
            if let dietId = suggestion.dietId {
                dietDictionary[dietId] = DietaryAttribute(
                    id: Int(dietId),
                    name: suggestion.title
                )
            }

        case .custom: break
        }
    }
    
    static func add(searchString: String) {
        // Ensure uniqueness, then append so most recent ends up at the end
        SearchDataStore.recentSearches.removeAll { $0 == searchString }
        SearchDataStore.recentSearches.append(searchString)
        SearchDataStore.registerRecentSearches()
    }
    
    static func remove(searchString: String) {
        SearchDataStore.recentSearches.removeAll { $0 == searchString }
        SearchDataStore.registerRecentSearches()
    }
}

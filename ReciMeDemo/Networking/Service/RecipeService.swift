//
//  RecipeService.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Moya

final class RecipeService: BaseService {
    func fetchAllRecipes() async throws -> [Recipe] {
        try await request(RecipeAPI.fetchAllRecipes)
    }
    
    func fetchDiets() async throws -> [DietaryAttribute] {
        try await request(RecipeAPI.fetchDiets)
    }
    
    func fetchIngredients() async throws -> [Ingredient] {
        try await request(RecipeAPI.fetchIngredients)
    }
    
    func fetchRecipesBy(_ tag: RecipeTag) async throws -> [Recipe] {
        try await request(RecipeAPI.fetchRecipes(by: tag))
    }
    
    func searchRecipes(filter: RecipeFilter) async throws -> [Recipe] {
        try await request(RecipeAPI.searchRecipes(filter: filter))
    }
}

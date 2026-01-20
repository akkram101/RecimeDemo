//
//  HomeVM.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation
import SwiftUI

@Observable
class HomeVM {
    let service: RecipeService
    
    private(set) var recipes: Loadable<[Recipe]> = .idle
    private(set) var recommendedRecipes: Loadable<[Recipe]> = .idle
    
    init(service: RecipeService = RecipeService()) {
        self.service = service
    }
    
    func fetchData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchRecipes() }
            group.addTask { await self.fetchRecommendedRecipes() }
        }
    }
    
    func fetchRecipes() async {
        // Only set to loading if we don't already have successful data
        if !recipes.hasValue {
            recipes = .loading
        }
        
        do {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            let result = try await service.fetchAllRecipes()
            recipes = .success(result)
        } catch {
            recipes = .failure(error)
        }
    }
    
    func fetchRecommendedRecipes() async {
        do {
            let recipes = try await service.fetchRecipesBy(.recommended)
            let limitedRecipes = Array(recipes.prefix(9))
            await MainActor.run {
                self.recommendedRecipes = .success(limitedRecipes)
            }
        } catch {
            await MainActor.run {
                self.recommendedRecipes = .failure(error)
            }
        }
    }

}

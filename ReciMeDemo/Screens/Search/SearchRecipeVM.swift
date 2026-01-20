//
//  SearchRecipeVM.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation
import SwiftUI
import Combine

///Marked with @MainActor so tasks will automatically hop to main thread after async network calls
///No need for redudnant await MainActor.run or DispatchQueue.main.async
@MainActor
@Observable
class SearchRecipeVM {
    private(set) var recentSearches: Loadable<[String]> = .idle
    private(set) var recommendedRecipes: Loadable<[Recipe]> = .idle
    private(set) var searchResults: Loadable<[Recipe]> = .idle
    private(set) var ingredients: Loadable<[Ingredient]> = .idle
    private(set) var diets: Loadable<[DietaryAttribute]> = .idle
    
    var filter = RecipeFilter()
    
    private let service: RecipeService
    
    var searchText: String = ""
    
    init(service: RecipeService = RecipeService()) {
        self.service = service
    }
    
    //MARK: User Actions
    func submitSearch(_ searchString: String) async {
        guard !searchString.isEmpty else { return }
        
        SearchDataStore.add(searchString: searchString)
        filter.searchText = searchString
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.searchRecipes() }
            group.addTask { await self.fetchRecentSearches() }
        }
    }
    
    func removeSearch(_ searchString: String) async {
        guard !searchString.isEmpty else { return }
        
        SearchDataStore.remove(searchString: searchString)
        await self.fetchRecentSearches()
    }
    
    func searchRecipes() async {
        searchResults = .loading
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        do {
            let recipes = try await service.searchRecipes(filter: filter)
            
            //Simulate backend filtering
            let filtered = MockRecipeFilterSimulator.applyFilter(
                filter,
                to: recipes,
                ingredientLookup: SearchDataStore.ingredientDictionary,
                dietLookup: SearchDataStore.dietDictionary
            )
            
            self.searchResults = .success(filtered)
        } catch {
            self.searchResults = .failure(error)
        }
    }
    
    func resetSearchResults() {
        self.searchResults = .idle
    }
}

//MARK: Network
extension SearchRecipeVM {
    func requestData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchRecentSearches() }
            group.addTask { await self.fetchRecommendedRecipes() }
            group.addTask { await self.fetchIngredients() }
            group.addTask { await self.fetchDiets() }
        }
    }
    
    /// Usually from response but for demo app use data store so we can add
    func fetchRecentSearches() async {
        // Show most recent searches first
        let ordered = Array(SearchDataStore.recentSearches.reversed())
        recentSearches = .success(ordered)
    }
    
    func fetchRecommendedRecipes() async {
        do {
            let recipes = try await service.fetchRecipesBy(.recommended)
            let limitedRecipes = Array(recipes.prefix(9))
//            self.recommendedRecipes = .success(limitedRecipes)
        } catch {
            self.recommendedRecipes = .failure(error)
        }
    }

    func fetchIngredients() async {
        do {
            let result = try await service.fetchIngredients()
            self.ingredients = .success(result)
            SearchDataStore.registerIngredients(result) //to show in suggestion when searching
        } catch {
            self.ingredients = .failure(error)
        }
    }

    func fetchDiets() async {
        do {
            let result = try await service.fetchDiets()
            self.diets = .success(result)
            SearchDataStore.registerDiets(result) //to show in suggestion when searching
        } catch {
            self.diets = .failure(error)
        }
    }
}

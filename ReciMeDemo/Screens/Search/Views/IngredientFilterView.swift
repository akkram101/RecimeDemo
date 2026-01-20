//
//  IngredientFilterView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/19/26.
//

import SwiftUI

struct IngredientFilterView: View {
    @Environment(SearchRecipeVM.self) var viewModel
    
    @Binding var filter: RecipeFilter
    @State private var query: String = ""
    @State private var showAllResults = false
    
    // MARK: - Helpers
    
    private func availableIngredients(from all: [Ingredient]) -> [Ingredient] {
        all.filter {
            !filter.isIngredientIncluded($0) &&
            !filter.isIngredientExcluded($0)
        }
    }
    
    private var hasIngredientFilters: Bool {
        let hasIncluded = !(filter.includeIngredients?.isEmpty ?? true)
        let hasExcluded = !(filter.excludeIngredients?.isEmpty ?? true)
        return hasIncluded || hasExcluded
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            switch viewModel.ingredients {
            case .success(let value):
                VStack(alignment: .leading, spacing: 12) {
                    if hasIngredientFilters {
                        HStack(alignment: .top) {
                            if let included = filter.includeIngredients, !included.isEmpty {
                                includedSection(ingredients: included)
                            }
                            Spacer()
                            
                            if let excluded = filter.excludeIngredients, !excluded.isEmpty {
                                excludedSection(ingredients: excluded)
                            }
                   
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    searchSection(ingredients: value)
                }
                
            default:
                EmptyView()
            }
        }
    }
    
    
    
    // MARK: - Subviews
    private func includedSection(ingredients: [Ingredient]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Included")
                .poppinsRegular(size: 14)
                .foregroundStyle(.black)
            
            ForEach(ingredients, id: \.ingredientId) { ingredient in
                ingredientRow(ingredient,
                              color: .green,
                              onRemove: { viewModel.filter.removeIncludeIngredient($0) })
            }
        }
    }
    
    private func excludedSection(ingredients: [Ingredient]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Excluded")
                .poppinsRegular(size: 14)
                .foregroundStyle(.black)
            
            ForEach(ingredients, id: \.ingredientId) { ingredient in
                ingredientRow(ingredient,
                              color: .red,
                              onRemove: { viewModel.filter.removeExcludeIngredient($0) })
            }
        }
    }
    
    private func ingredientRow(_ ingredient: Ingredient,
                               color: Color,
                               onRemove: @escaping (Ingredient) -> Void) -> some View {
        HStack {
            Text(ingredient.name ?? "")
                .poppinsRegular(size: 12)
                .foregroundColor(color)
            
            Spacer()
            
            Button {
                onRemove(ingredient)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.1))
        )
    }
    
    
    private func searchSection(ingredients: [Ingredient]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SearchTextField(
                enableAutoSearch: true,
                onType: { typed in query = typed },
                onSearch: { typed in query = typed }
            )
            
            let filteredResults: [Ingredient] = {
                guard !query.isEmpty else { return availableIngredients(from: ingredients) }
                return availableIngredients(from: ingredients)
                    .filter { $0.name?.localizedCaseInsensitiveContains(query) ?? false }
            }()
            
            let displayedResults = showAllResults ? filteredResults : Array(filteredResults.prefix(5))
            
            searchRows(displayedResults)
            
            if filteredResults.count > 5 {
                Button(action: { showAllResults.toggle() }) {
                    Text(showAllResults ? "Show Less" : "Show All")
                        .poppinsRegular(size: 12)
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    private func searchRows(_ ingredients: [Ingredient]) -> some View {
        VStack(spacing: 6) {
            ForEach(ingredients, id: \.ingredientId) { ingredient in
                HStack {
                    Text(ingredient.name ?? "")
                        .poppinsRegular(size: 12)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button {
                        filter.addExcludeIngredient(ingredient)
                    } label: {
                        Image(systemName: "minus")
                            .foregroundColor(.red)
                    }
                    
                    Button {
                        filter.addIncludeIngredient(ingredient)
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(AppColors.primary)
                    }
                }
                .padding(.vertical, 6)
            }
        }
    }
}

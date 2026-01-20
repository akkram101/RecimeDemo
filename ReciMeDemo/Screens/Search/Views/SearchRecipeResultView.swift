//
//  SearchResultsView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct SearchRecipeResultView: View {
    @Environment(SearchRecipeVM.self) var viewModel
    let recipes: [Recipe]
    let onRecipeTap: (Recipe) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if recipes.isEmpty {
                EmptySearchView(searchedString: viewModel.searchText)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(recipes.enumerated()), id: \.offset) { index, recipe in
                            RecipeRow(recipe: recipe)
                            .padding(.bottom, 12)
                            .overlay(alignment: .bottom) {
                                if index < recipes.count {
                                    separatorLine
                                }
                            }
                            .onTapGesture {
                                onRecipeTap(recipe)
                            }
                        }
                    }
                }
                .scrollDismissesKeyboard(.immediately)
            }
        }
    }
    
    private var separatorLine: some View {
        Rectangle()
            .fill(Color.black.opacity(0.1))
            .frame(height: 1)
    }
}


// MARK: - Preview
extension Recipe {
    static let mockList: [Recipe] = [
        Recipe(title: "Spaghetti Carbonara", recipeDescription: "Classic Italian pasta with eggs, cheese, pancetta."),
        Recipe(title: "Chicken Curry", recipeDescription: "Spicy and creamy curry with tender chicken."),
        Recipe(title: "Avocado Toast", recipeDescription: "Simple breakfast with smashed avocado and bread.")
    ]
}

#Preview {
    @Previewable @State var viewModel = SearchRecipeVM()
    SearchRecipeResultView(recipes: Recipe.mockList) { recipe in
        
    }
    .environment(viewModel)
}

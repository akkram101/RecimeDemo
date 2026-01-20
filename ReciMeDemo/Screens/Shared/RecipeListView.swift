//
//  RecipeListView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct RecipeListView: View {
    let recipes: [Recipe]
    let onRecipeTap: (Recipe) -> Void
    var body: some View {
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
    }
    
    private var separatorLine: some View {
        Rectangle()
            .fill(Color.black.opacity(0.1))
            .frame(height: 1)
    }
}

#Preview {
    RecipeListView(recipes: Recipe.mockList) { recipe in
        
    }
}

//
//  RecipeRow.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Image(recipe.randomImage)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(alignment: .topLeading) {
                    tagView()
                }
                .overlay(alignment: .topTrailing) {
                    bookmarkIcon
                }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(recipe.title)
                    .poppinsMedium(size: 12)
                    .foregroundStyle(.black)
                Text(recipe.recipeDescription)
                    .poppinsRegular(size: 10)
                    .foregroundStyle(Color.init(hex: "888888"))
                    .lineLimit(2)
                Text("Servings: \(recipe.servings)")
                    .poppinsRegular(size: 10)
                    .foregroundStyle(Color.init(hex: "888888"))
                
                HStack(spacing: 2) {
                    Text("Diet:")
                        .poppinsRegular(size: 10)
                        .foregroundStyle(Color.init(hex: "888888"))
                    ForEach(recipe.dietaryAttributes, id: \.self) { id in
                        let dietUI = DietaryAttributeUI(id: id)
                        Text("\(dietUI.displayName)")
                            .poppinsRegular(size: 10)
                            .foregroundStyle(dietUI.color)
                    }

                }
            }
        }
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private func tagView() -> some View {
        if let tag = recipe.tag?.first , let recipeTag = RecipeTag(rawValue: tag) {
            let uiAttr = RecipeTagUI(tag: recipeTag)
            Text(uiAttr.displayName)
               .poppinsRegular(size: 12)
               .padding(.horizontal, 8)
               .padding(.vertical, 6)
               .background {
                   UnevenRoundedRectangle(cornerRadii: .init(topLeading: 8, bottomTrailing: 16))
                       .fill(uiAttr.color.gradient)
               }
               .foregroundStyle(.white)
        }
    }
    
    //Just for different UI purposes
    private var bookmarkIcon: some View {
        Image(systemName: ["bookmark.fill", "bookmark"].randomElement()!)
            .resizable()
            .scaledToFit()
            .frame(height: 24)
            .foregroundStyle(.yellow)
            .padding(6)
    }
}

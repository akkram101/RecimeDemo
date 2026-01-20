//
//  RecipeDesciption.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct RecipeDescription: View {
    let recipe: Recipe
    
    @Environment(CookingManager.self) var cookingManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    recipeImage
                       
                    VStack(alignment: .leading, spacing: 16) {
                        recipeHeader
                        recipeServings
                        recipeTextDescription()
                        recipeIngredients
                        recipeInstructions
                    }
                    .safeAreaPadding(12)
                }
                .overlay(alignment: .topLeading) {
                    closeBtn
                }
            }
            .ignoresSafeArea(.container, edges: .top)
            .safeAreaInset(edge: .bottom) {
                Spacer().frame(height:40) //Button height
            }
            
            startCookButton
                .padding(12)
        }
        .background(.white)
        .navigationBarBackButtonHidden(true)
        
    }
}

// MARK: - Components

extension RecipeDescription {
    
    private var closeBtn: some View {
        Image(systemName: "xmark")
            .resizable()
            .scaledToFit()
            .frame(width: 16)
            .padding(12)
            .foregroundStyle(.black)
            .background(Circle().fill(.white))
            .onTapGesture { dismiss() }
            .ignoresSafeArea()
            .padding(.top, 48)
            .padding(.leading, 12)
    }
    
    /// Recipe Image
    private var recipeImage: some View {
        Image(recipe.randomImage)
            .resizable()
            .scaledToFill()
            .frame(height: 250)
            .clipped()
    }
    
    /// Title + Tags + Diets
    private var recipeHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.title)
                .poppinsBold(size: 24)
                .foregroundStyle(.black)
            
            HStack(spacing: 8) {
                tagView
                dietaryAttributesView
            }
        }
    }
    
    /// Description
    @ViewBuilder
    private func recipeTextDescription() -> some View {
        let description = """
        \(recipe.recipeDescription)\n
        Lorem ipsum dolor sit amet consectetur adipiscing elit. Consectetur adipiscing elit quisque faucibus ex sapien vitae. Ex sapien vitae pellentesque sem placerat in id. Placerat in id cursus mi pretium tellus duis. Pretium tellus duis convallis tempus leo eu aenean.
        """
        Text(description)
            .poppinsRegular(size: 12)
            .foregroundStyle(Color.init(hex: "888888"))
        
    }
    
    /// Servings
    private var recipeServings: some View {
        Text("Servings: \(recipe.servings)")
            .poppinsRegular(size: 12)
            .foregroundStyle(Color.init(hex: "888888"))
    }
    
    /// Ingredients
    private var recipeIngredients: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients")
                .poppinsMedium(size: 14)
                .foregroundStyle(.black)
            ForEach(recipe.ingredients, id: \.ingredientId) { ingredient in
                HStack {
                    Text(ingredient.name ?? "")
                    Spacer()
                    Text(ingredient.quantity ?? "")
                        .foregroundStyle(Color.init(hex: "888888"))
                }
                .poppinsRegular(size: 12)
                .foregroundStyle(Color.init(hex: "888888"))
            }
        }
    }
    
    /// Instructions
    private var recipeInstructions: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Instructions")
                .poppinsMedium(size: 14)
                .foregroundStyle(.black)
            ForEach(recipe.instructions.indices, id: \.self) { idx in
                Text("\(idx + 1). \(recipe.instructions[idx].description)")
                    .poppinsRegular(size: 12)
                    .foregroundStyle(Color.init(hex: "888888"))
            }
        }
    }
    
    /// Start Cooking Button
    private var startCookButton: some View {
        PrimaryButton(title: "Start Cooking") {
            cookingManager.startCooking(recipe: recipe)
            dismiss()
        }
    }
    
    /// Tag View
    private var tagView: some View {
        Group {
            if let tag = recipe.tag?.first,
               let recipeTag = RecipeTag(rawValue: tag) {
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
    }
    
    /// Dietary Attributes View
    private var dietaryAttributesView: some View {
        ForEach(recipe.dietaryAttributes, id: \.self) { attr in
            let uiAttr = DietaryAttributeUI(id: attr)
                Text(uiAttr.displayName)
                    .poppinsRegular(size: 12)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background {
                        Capsule()
                            .fill(uiAttr.color.gradient)
                    }
                    .foregroundStyle(.white)
            }
        
    }
}

#Preview {
    RecipeDescription(
        recipe: Recipe(
            title: "Pasta Primavera",
            recipeDescription: "A fresh and vibrant pasta dish with seasonal vegetables.",
            servings: 4,
            ingredients: [
                Ingredient(ingredientId: 1, name: "Pasta", quantity: "200g"),
                Ingredient(ingredientId: 2, name: "Tomatoes", quantity: "2"),
                Ingredient(ingredientId: 3, name: "Olive Oil", quantity: "2 tbsp")
            ],
            instructions: [
                InstructionStep(description: "Boil pasta until al dente."),
                InstructionStep(description: "Sauté vegetables in olive oil."),
                InstructionStep(description: "Mix pasta with vegetables and serve.")
            ],
            tag: [1],
            dietaryAttributes: [2, 3]
        )
    )
}


#Preview {
    RecipeDescription(
        recipe: Recipe(
            title: "Pasta Primavera",
            recipeDescription: "A fresh and vibrant pasta dish with seasonal vegetables.",
            servings: 4,
            ingredients: [
                Ingredient(ingredientId: 1, name: "Pasta", quantity: "200g"),
                Ingredient(ingredientId: 2, name: "Tomatoes", quantity: "2"),
                Ingredient(ingredientId: 3, name: "Olive Oil", quantity: "2 tbsp")
            ],
            instructions: [
                InstructionStep(description: "Boil pasta until al dente."),
                InstructionStep(description: "Sauté vegetables in olive oil."),
                InstructionStep(description: "Mix pasta with vegetables and serve.")
            ],
            tag: [1],
            dietaryAttributes: [2, 3]
        )
    )
}


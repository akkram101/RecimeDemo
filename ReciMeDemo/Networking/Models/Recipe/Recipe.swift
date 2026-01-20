//
//  RecipeDTO.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation
import SmartCodable

struct Recipe: SmartCodableX, Identifiable, Hashable {
    var id: UUID? = UUID()
    var title: String = ""
    var recipeDescription: String = ""
    var servings: Int = 0
    var ingredients: [Ingredient] = []
    var instructions: [InstructionStep] = []
    var tag: [Int]? = []
    var dietaryAttributes: [Int] = []
    
    // MARK: - Equatable
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension Recipe {
    // Random image for visual purposes
    var randomImage: String {
        return "food_\(Int.random(in: 1...21))"
    }
}

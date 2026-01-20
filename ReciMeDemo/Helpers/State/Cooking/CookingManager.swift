//
//  CookingManager.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import Foundation
import SwiftUI
import Observation

@Observable
class CookingManager {
    // MARK: - State
    private(set) var currentRecipe: Recipe? = nil
    private(set) var currentStep: InstructionStep? = nil
    
    // MARK: - Actions
    func startCooking(recipe: Recipe) {
        currentRecipe = recipe
        currentStep = recipe.instructions.first
    }
    
    func endCooking() {
        currentRecipe = nil
        currentStep = nil
    }
    
    func advanceStep() {
        if let recipe = currentRecipe,
           let step = currentStep,
           let index = recipe.instructions.firstIndex(where: { $0.stepNumber == step.stepNumber }) {
            currentStep = recipe.instructions[index + 1]
        }
    }
    
    func goBackStep() {
        guard let recipe = currentRecipe,
              let step = currentStep,
              let index = recipe.instructions.firstIndex(of: step),
              index > 0 else { return }
        
        currentStep = recipe.instructions[index - 1]
    }
    
    // MARK: - Helpers
    var isCooking: Bool {
        currentRecipe != nil
    }
    
    var stepIndex: Int? {
        guard let recipe = currentRecipe,
              let step = currentStep else { return nil }
        return recipe.instructions.firstIndex(of: step)
    }
}

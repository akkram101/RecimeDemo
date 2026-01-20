//
//  DietFilterView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/19/26.
//

import SwiftUI

struct DietFilterView: View {
    @Environment(SearchRecipeVM.self) var viewModel
    
    @Binding var filter: RecipeFilter
    
    /// Convenience accessor for selected diets
    private var selectedDiets: [DietaryAttribute] {
        filter.dietaryAttributes ?? []
    }
    
    var body: some View {
        switch viewModel.diets {
        case .success(let diets):
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(diets, id: \.id) { diet in
                    let isDietSelected = selectedDiets.contains(where: { $0.id == diet.id })
                    Button(action: {
                        if isDietSelected {
                            filter.removeDietaryAttribute(diet)
                        } else {
                            filter.addDietaryAttribute(diet)
                        }
                    }) {
                        Text(diet.name)
                            .poppinsRegular(size: 12)
                            .foregroundColor(isDietSelected ? .white : .black)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isDietSelected ? AppColors.primary : Color.gray.opacity(0.1))
                            )
                            .animation(.snappy(duration: 0.2), value: selectedDiets.contains(where: { $0.id == diet.id }))
                    }
                    .buttonStyle(AnimatedButtonStyle())
                }
            }
            .drawingGroup()
            
        default:
            EmptyView()
        }
    }
}

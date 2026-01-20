//
//  ServingsFilterView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/19/26.
//

import SwiftUI

struct ServingsFilterView: View {
    @Binding var filter: RecipeFilter
    
    var body: some View {
        Slider(
            value: Binding(
                get: { Double(filter.servings ?? 1) },
                set: { newValue in filter.setServings(Int(newValue)) }
            ),
            in: 1...10,
            step: 1
        )
        .tint(AppColors.primary)
        .padding(.horizontal, 2)
    }
}

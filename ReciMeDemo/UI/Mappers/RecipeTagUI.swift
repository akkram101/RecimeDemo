//
//  RecipeTagUI.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct RecipeTagUI {
    let tag: RecipeTag
    
    var displayName: String {
        tag.displayName
    }
    
    var color: Color {
        switch tag {
        case .popular: return .red
        case .recommended: return .blue
        case .new: return .green
        case .trending: return .orange
        case .seasonal: return .purple
        case .chefSpecial: return .pink
        }
    }
    
    var icon: String {
        switch tag {
        case .popular: return "flame.fill"
        case .recommended: return "star.fill"
        case .new: return "sparkles"
        case .trending: return "chart.line.uptrend.xyaxis"
        case .seasonal: return "leaf.fill"
        case .chefSpecial: return "fork.knife"
        }
    }
}

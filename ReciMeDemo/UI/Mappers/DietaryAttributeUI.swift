//
//  DietaryAttributeUI.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import Foundation
import SwiftUI

struct DietaryAttributeUI {
    let id: Int
    
    var displayName: String {
        switch id {
        case 1: return "Vegan"
        case 2: return "Vegetarian"
        case 3: return "Gluten-Free"
        case 4: return "Dairy-Free"
        case 5: return "Keto"
        case 6: return "Paleo"
        case 7: return "Pescetarian"
        case 8: return "Halal"
        case 9: return "Kosher"
        case 10: return "Low-Carb"
        default: return "Unknown"
        }
    }
    
    var color: Color {
        switch id {
        case 1: return .green
        case 2: return .purple
        case 3: return .orange
        case 4: return .blue
        case 5: return .pink
        case 6: return .brown
        case 7: return .cyan
        case 8: return .mint
        case 9: return .indigo
        case 10: return .teal
        default: return .gray
        }
    }
}


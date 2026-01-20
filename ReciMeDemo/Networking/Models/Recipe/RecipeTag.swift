//
//  RecipeTag.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation

enum RecipeTag: Int, CaseIterable {
    case popular = 1
    case recommended = 2
    case new = 3
    case trending = 4
    case seasonal = 5
    case chefSpecial = 6

    var displayName: String {
        switch self {
        case .popular: return "Popular"
        case .recommended: return "Recommended"
        case .new: return "New"
        case .trending: return "Trending"
        case .seasonal: return "Seasonal"
        case .chefSpecial: return "Chef's Special"
        }
    }
}

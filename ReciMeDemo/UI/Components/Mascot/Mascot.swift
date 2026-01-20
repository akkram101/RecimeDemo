//
//  Mascot.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//


import SwiftUI

enum MascotType: String {
    case happy
    case thankful
    case idea
    case teaching
    case love
    case hi
    case bye
    case noRecipes
    case success
    case sleepy
    case error

    var imageName: String {
        switch self {
        case .happy:        return "mascot_happy"
        case .thankful:     return "mascot_thankful"
        case .idea:         return "mascot_idea"
        case .teaching:     return "mascot_teaching"
        case .love:         return "mascot_love"
        case .hi:           return "mascot_hi"
        case .bye:          return "mascot_bye"
        case .noRecipes:    return "mascot_no_recipes"
        case .success:     return "mascot_success"
        case .sleepy:      return "mascot_sleepy"
        case .error:       return "mascot_error"
        }
    }
}

struct Mascot: View {
    let type: MascotType
    var flippedHorizontally: Bool = false
    
    init(_ type: MascotType, flippedHorizontally: Bool = false) {
        self.type = type
        self.flippedHorizontally = flippedHorizontally
    }

    var body: some View {
        Image(type.imageName)
            .resizable()
            .scaledToFit()
            .scaleEffect(x: flippedHorizontally ? -1 : 1, y: 1)
    }
}


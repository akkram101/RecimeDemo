//
//  Ingredient.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SmartCodable

struct Ingredient: SmartCodableX {
    var ingredientId: Int? = 0
    var name: String? = ""
    var quantity: String? = ""
    var isOptional: Bool? = false
}

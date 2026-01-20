//
//  RecipeAPI.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation
import Moya

enum RecipeAPI {
    case fetchAllRecipes
    case fetchAllIngredients
    case fetchRecipes(by: RecipeTag)
    case fetchDiets
    case fetchIngredients
    case searchRecipes(filter: RecipeFilter)
}


extension RecipeAPI: MockableTarget {
    var baseURL: URL { API.baseURL }
    
    var headers: [String : String]? { API.defaultHeaders }

    var path: String {
        switch self {
        case .fetchAllRecipes:
            return API.Endpoints.recipes
        case .fetchRecipes(let tag):
            return API.Endpoints.recipeByTag(tag)
        case .fetchAllIngredients:
            return API.Endpoints.ingredients
        case .fetchDiets:
            return API.Endpoints.diets
        case .fetchIngredients:
            return API.Endpoints.ingredients
        case .searchRecipes(filter: _):
            return API.Endpoints.searchRecipes
        }
    }

    var method: Moya.Method { .get }

    var task: Task {
        switch self {
        case .fetchRecipes(by: let tag):
            return .requestParameters(
                parameters: ["tag": tag.rawValue],
                encoding: URLEncoding.queryString
            )
        case .searchRecipes(filter: let filter):
            return .requestParameters(
                parameters: filter.toParameters(),
                encoding: URLEncoding.queryString
            )
        default:
            return .requestPlain
        }
    }
    
    var mockFileName: String? {
        switch self {
        case .fetchAllRecipes, .searchRecipes: return "recipes_mock"
        case .fetchRecipes(by: let tag):
            switch tag {
            case .popular:
                return  "recipes_popular_mock"
            case .recommended:
                return "recipes_recommended_mock"
            default: return nil
            }
        case .fetchDiets: return "recipes_diets_mock"
        case .fetchIngredients: return "recipes_ingredients_mock"
        default: return nil
        }
    }
}

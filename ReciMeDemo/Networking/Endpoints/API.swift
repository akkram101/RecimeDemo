//
//  API.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation

enum API {
    // MARK: - Environment
    enum Environment {
        case development
        case staging
        case production

        var baseURL: URL {
            switch self {
            case .development:
                return URL(string: "https://dev.recime.com")!
            case .staging:
                return URL(string: "https://staging.recime.com")!
            case .production:
                return URL(string: "https://recime.com")!
            }
        }
    }

    static let environment: Environment = .production
    static var baseURL: URL { environment.baseURL }

    // MARK: - Default Headers
    static let defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
        "Accept": "application/json"
        //"Authorization": "Bearer <token>"
    ]
}

// MARK: - Endpoints
extension API {
    enum Endpoints {
        // Recipes
        static let recipes = "/recipes"
        static func recipeByTag(_ tag: RecipeTag) -> String { "/recipes/\(tag.rawValue)" }
        static let diets = "/recipes/diets"
        static let ingredients = "/recipes/ingredients"
        static let searchRecipes = "/recipes/search/"
        
        // Auth
        static let login = "/auth/login"
        static let signup = "/auth/signup"
        static let refresh = "/auth/refresh"
        static let logout = "/auth/logout"
        
        // Users
        static let userProfile = "/users"
        static func userById(_ id: String) -> String { "/users/\(id)" }
        static func updateUser(_ id: String) -> String { "/users/\(id)" }
        static func userFavorites(_ id: String) -> String { "/users/\(id)/favorites" }
        static func addFavorite(_ userId: String, recipeId: String) -> String { "/users/\(userId)/favorites/\(recipeId)" }
        
        // Community
        static let posts = "/community/posts"
        static func postById(_ id: String) -> String { "/community/posts/\(id)" }
        static let comments = "/community/comments"
        static func commentsForPost(_ postId: String) -> String { "/community/posts/\(postId)/comments" }
        static let likes = "/community/likes"
        static func likePost(_ postId: String) -> String { "/community/posts/\(postId)/likes" }
    }
}

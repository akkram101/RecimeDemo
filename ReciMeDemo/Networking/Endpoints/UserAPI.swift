//
//  UserAPI.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation
import Moya

enum UserAPI {
    case fetchProfile(userId: String)
    case updateProfile(userId: String, name: String, email: String)
    case addFavorite(userId: String, recipeId: String)
    case fetchFavorites(userId: String)
}

extension UserAPI: TargetType {
    var baseURL: URL { API.baseURL }
    
    var path: String {
        switch self {
        case .fetchProfile(let userId): return API.Endpoints.userById(userId)
        case .updateProfile(let userId, _, _): return API.Endpoints.updateUser(userId)
        case .addFavorite(let userId, let recipeId): return API.Endpoints.addFavorite(userId, recipeId: recipeId)
        case .fetchFavorites(let userId): return API.Endpoints.userFavorites(userId)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchProfile, .fetchFavorites:
            return .get
        case .updateProfile:
            return .put
        case .addFavorite:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchProfile, .fetchFavorites, .addFavorite:
            return .requestPlain
            
        case .updateProfile(_, let name, let email):
            return .requestParameters(
                parameters: [
                    "name": name,
                    "email": email
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String : String]? { API.defaultHeaders }
}

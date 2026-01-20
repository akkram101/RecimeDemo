//
//  UserService.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Moya

final class UserService: BaseService {
    func fetchProfile(userId: String) async throws -> User {
        try await request(UserAPI.fetchProfile(userId: userId))
    }
    
    func updateProfile(userId: String, name: String, email: String) async throws -> User {
        try await request(UserAPI.updateProfile(userId: userId, name: name, email: email))
    }
    
    func addFavorite(userId: String, recipeId: String) async throws -> Recipe {
        try await request(UserAPI.addFavorite(userId: userId, recipeId: recipeId))
    }
    
    func fetchFavorites(userId: String) async throws -> [Recipe] {
        try await request(UserAPI.fetchFavorites(userId: userId))
    }
}

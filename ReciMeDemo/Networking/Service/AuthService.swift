//
//  AuthService.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Moya

final class AuthService: BaseService {
    func login(email: String, password: String) async throws -> AuthResponse {
        try await request(AuthAPI.login(email: email, password: password))
    }
    
    func signup(name: String, email: String, password: String) async throws -> AuthResponse {
        try await request(AuthAPI.signup(name: name, email: email, password: password))
    }
    
    func refresh(token: String) async throws -> AuthResponse {
        try await request(AuthAPI.refresh(token: token))
    }
    
    func logout(userId: String) async throws -> Bool {
        try await request(AuthAPI.logout(userId: userId))
    }
}

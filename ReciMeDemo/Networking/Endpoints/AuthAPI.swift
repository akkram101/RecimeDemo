//
//  AuthAPI.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation
import Moya

enum AuthAPI {
    case login(email: String, password: String)
    case signup(name: String, email: String, password: String)
    case refresh(token: String)
    case logout(userId: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL { API.baseURL }
    
    var headers: [String : String]? { API.defaultHeaders }

    var path: String {
        switch self {
        case .login: return API.Endpoints.login
        case .signup: return API.Endpoints.signup
        case .refresh: return API.Endpoints.refresh
        case .logout: return API.Endpoints.logout
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .signup, .refresh: return .post
        case .logout: return .delete
        }
    }

    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(
                parameters: [
                    "email": email,
                    "password": password
                ],  encoding: JSONEncoding.default)
        case .signup(let name, let email, let password):
            return .requestParameters(
                parameters: [
                    "name": name,
                    "email": email,
                    "password": password
                ], encoding: JSONEncoding.default)
        case .refresh(let token):
            return .requestParameters(
                parameters: [
                    "token": token
                ], encoding: JSONEncoding.default)
        case .logout(let userId):
            return .requestParameters(
                parameters: [
                    "userId": userId]
                , encoding: JSONEncoding.default)
        }
    }
}

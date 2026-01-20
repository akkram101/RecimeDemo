//
//  CommunityAPI.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation
import Moya

enum CommunityAPI {
    case fetchAllPosts
    case createPost(userId: String, content: String)
    case addComment(postId: String, userId: String, comment: String)
    case likePost(postId: String, userId: String)
}

extension CommunityAPI: TargetType {
    var baseURL: URL { API.baseURL }
    
    var headers: [String : String]? { API.defaultHeaders }

    var path: String {
        switch self {
        case .fetchAllPosts: return API.Endpoints.posts
        case .createPost: return API.Endpoints.posts
        case .addComment: return API.Endpoints.comments
        case .likePost: return API.Endpoints.likes
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchAllPosts: return .get
        case .createPost: return .post
        case .addComment: return .post
        case .likePost: return .post
        }
    }

    var task: Task {
        switch self {
        case .fetchAllPosts:
            return .requestPlain
        case .createPost(let userId, let content):
            return .requestParameters(
                parameters: [
                    "userId": userId,
                    "content": content
                ], encoding: JSONEncoding.default)
        case .addComment(let postId, let userId, let comment):
            return .requestParameters(
                parameters: [
                    "postId": postId,
                    "userId": userId,
                    "comment": comment], encoding: JSONEncoding.default)
        case .likePost(let postId, let userId):
            return .requestParameters(
                parameters: [
                    "postId": postId,
                    "userId": userId]
                , encoding: JSONEncoding.default)
        }
    }
}

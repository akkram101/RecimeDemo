//
//  CommunityService.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Moya

final class CommunityService: BaseService {
    func fetchAllPosts() async throws -> [Post] {
        try await request(CommunityAPI.fetchAllPosts)
    }
    
    func createPost(userId: String, content: String) async throws -> Post {
        try await request(CommunityAPI.createPost(userId: userId, content: content))
    }
    
    func addComment(postId: String, userId: String, comment: String) async throws -> Comment {
        try await request(CommunityAPI.addComment(postId: postId, userId: userId, comment: comment))
    }
    
    func likePost(postId: String, userId: String) async throws -> Post {
        try await request(CommunityAPI.likePost(postId: postId, userId: userId))
    }
}

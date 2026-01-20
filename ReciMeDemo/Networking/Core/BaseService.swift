//
//  BaseService.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Moya
import SmartCodable
import UIKit

struct NetworkProvider {
    static let shared = MoyaProvider<MultiTarget>(
        plugins: [NetworkLoggerPlugin()]
    )
}

class BaseService {
    let provider: MoyaProvider<MultiTarget>
    
    var useMockData: Bool = true
    
    init(provider: MoyaProvider<MultiTarget> = NetworkProvider.shared) {
        self.provider = provider
    }
    
    func request<T: Decodable>(
        target: TargetType,
        type: T.Type
    ) async throws -> T {
        
        // If target supports mock and global flag is ON
        if useMockData, let mockable = target as? MockableTarget,
           let fileName = mockable.mockFileName {
            return try loadMockJSON(filename: fileName, type: type)
        }
        
        let response = try await withCheckedThrowingContinuation { continuation in
            provider.request(MultiTarget(target)) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
        return try parseResponse(response.data, type: type)
    }
    
    func request<T: Decodable>(_ target: TargetType) async throws -> T {
        try await request(target: target, type: T.self)
    }
    
    private func loadMockJSON<T: Decodable>(filename: String, type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NetworkError.emptyData
        }
        let data = try Data(contentsOf: url)
        return try parseResponse(data, type: type)
    }
    
    private func parseResponse<T: Decodable>(_ data: Data, type: T.Type) throws -> T {
        let base = try SmartJSONDecoder().decode(BaseResponse<T>.self, from: data)
        
        guard let statusCode = base.head?.statusCode else {
            throw NetworkError.badResponse
        }
        
        switch statusCode {
        case 200...299:
            guard let value = base.body else {
                throw NetworkError.emptyData
            }
            return value
            
        case 401: throw NetworkError.unauthorized
        case 403: throw NetworkError.forbidden
        case 500: throw NetworkError.serverError
        case 503: throw NetworkError.serviceUnavailable
        default: throw NetworkError.invalidStatusCode(statusCode)
        }
    }


}

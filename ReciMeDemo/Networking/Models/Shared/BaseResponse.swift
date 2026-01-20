//
//  BaseResponse.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation
import SmartCodable

// Generic base response
struct BaseResponse<T: Decodable>: Decodable {
    var head: ResponseHead?
    var body: T?
}

// Response head
struct ResponseHead: SmartCodableX {
    var message: String?
    var statusCode: Int?
}

// Example body wrapper
struct ResponseBody: SmartCodableX {
    var data: Data?
}

// Pagination Response
struct PaginatedBody<T: SmartCodableX>: SmartCodableX {
    var items: [T]?
    var pagination: Pagination?
}

// Pagination Model
struct Pagination: SmartCodableX {
    var page: Int?
    var pageSize: Int?
    var totalItems: Int?
    var totalPages: Int?
    var hasNext: Bool?
    var hasPrevious: Bool?
}

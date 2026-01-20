//
//  NetworkError.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    // MARK: - Connectivity
    case noNetwork                // No internet connection
    case timeout                  // Request timed out
    case unreachableHost          // DNS failure or server unreachable

    // MARK: - Authentication
    case unauthorized             // 401 invalid/expired token
    case forbidden                // 403 user doesn’t have permission
    case tokenExpired             // custom case for refresh flow

    // MARK: - Response
    case badResponse              // Non 200 status code, malformed response
    case decodingFailed           // JSON decoding failed
    case emptyData                // Response body is empty when data expected
    case invalidStatusCode(Int)   // Unexpected status code

    // MARK: - Server
    case serverError              // 500 internal server error
    case serviceUnavailable       // 503 server down/maintenance

    // MARK: - Business Logic
    case custom(message: String)  // API returned error message in payload

    // MARK: - Unknown
    case unknown(Error)           // Catch‑all for unexpected errors

    // MARK: - User‑friendly descriptions
    var errorDescription: String? {
        switch self {
        case .noNetwork:
            return "No internet connection. Please check your network."
        case .timeout:
            return "The request timed out. Try again."
        case .unreachableHost:
            return "Server unreachable. Please try later."
        case .unauthorized, .tokenExpired:
            return "Your session expired. Please log in again."
        case .forbidden:
            return "You don’t have permission to access this resource."
        case .badResponse:
            return "Bad response from server."
        case .decodingFailed:
            return "Failed to process server response."
        case .emptyData:
            return "No data received from server."
        case .invalidStatusCode(let code):
            return "Unexpected status code: \(code)."
        case .serverError:
            return "Server error. Please try again later."
        case .serviceUnavailable:
            return "Service is temporarily unavailable."
        case .custom(let message):
            return message
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

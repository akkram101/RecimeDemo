//
//  Loadable.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI

enum Loadable<Value> {
    case idle
    case loading
    case success(Value)
    case failure(Error)
    
    /// Returns true if the state is `.loading`
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    /// Returns true if the state is `.success` with a non-empty value (when Value is a Collection)
    var hasValue: Bool {
        switch self {
        case .success(let value):
            if let collection = value as? any Collection {
                return !collection.isEmpty
            }
            return true
        default:
            return false
        }
    }
    
    /// Extracts the success value if present
    var value: Value? {
        if case .success(let value) = self { return value }
        return nil
    }
    
    /// Extracts the error if present
    var error: Error? {
        if case .failure(let error) = self { return error }
        return nil
    }
}

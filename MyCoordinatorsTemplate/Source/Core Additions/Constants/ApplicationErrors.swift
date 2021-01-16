//
//  ApplicationErrors.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 04.11.2020.
//

import Foundation

enum ApplicationErrors {
    
    enum ApiClient: Error {
        case notFound
        case invalidToken
        case serverError
        case invalidResponse
        case deserializationFailed
    }
    
    enum TokenRecoverError: Error, Equatable {
        case unauthorized
        case getTokenFailure(response: HTTPURLResponse, data: Data)
    }
    
    enum Location: Error {
        case noPermission
    }
    
    enum Network: Error {
        case noConnection
    }
    
    enum Unexpected: Error {
        case internalInconsistency
    }
}

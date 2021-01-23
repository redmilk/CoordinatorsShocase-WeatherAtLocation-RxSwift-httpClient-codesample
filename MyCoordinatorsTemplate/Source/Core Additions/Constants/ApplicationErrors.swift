//
//  ApplicationErrors.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 04.11.2020.
//

import Foundation

enum ApplicationErrors {
    
    enum ApiClient: Error, Equatable {
        case noConnection
        case notFound
        case unauthorized
        case serverError
        case invalidResponse
        case deserializationFailed
        case getTokenFailure(response: HTTPURLResponse, data: Data)
    }
    
    enum Location: Error {
        case noPermission
    }
    
    enum Unexpected: Error {
        case internalInconsistency
    }
}

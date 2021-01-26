//
//  ApplicationErrors.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 04.11.2020.
//

import Foundation

typealias ErrorInfo = (String, String)

struct ApplicationError: Error {
    let errorType: ApplicationErrors
    let errorInfo: ErrorInfo?
    
    init(errorType: ApplicationErrors, errorInfo: ErrorInfo? = nil) {
        self.errorType = errorType
        self.errorInfo = errorInfo
    }
    
    enum ApplicationErrors {
        case noConnection
        case notFound
        case unauthorized
        case serverError
        case invalidResponse
        case deserializationFailed
        case noLocationPermission
        case getTokenFailure(response: HTTPURLResponse, data: Data)
        case internalInconsistency
    }
}




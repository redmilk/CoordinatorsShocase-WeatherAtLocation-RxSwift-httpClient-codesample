//
//  ApplicationErrors.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 04.11.2020.
//

import Foundation

typealias ErrorContent = (title: String, message: String)

struct ApplicationError: Error {
    let errorType: ApplicationErrors
    let errorContent: ErrorContent?
    
    init(errorType: ApplicationErrors, errorContent: ErrorContent? = nil) {
        self.errorType = errorType
        self.errorContent = errorContent
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




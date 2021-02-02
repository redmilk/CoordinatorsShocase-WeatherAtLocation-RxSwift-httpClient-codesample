//
//  RequestParamsAdapter.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 13.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

struct RequestBuilder {

    private let baseUrl: URL
    private let pathComponent: String
    private let adapters: [URLRequestAdaptable]
    private let method: HTTPMethod
    private let timeoutInterval: TimeInterval
    
    var request: URLRequest {
        let url = baseUrl.appendingPathComponent(pathComponent)
        var request = URLRequest(url: url)
        adapters.forEach { $0.adapt(&request) }
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        return request
    }
    
    init(baseUrl: URL,
         pathComponent: String,
         adapters: [URLRequestAdaptable],
         method: HTTPMethod,
         timoutInterval: TimeInterval = 10.0
    ) {
        self.baseUrl = baseUrl
        self.pathComponent = pathComponent
        self.adapters = adapters
        self.method = method
        self.timeoutInterval = timoutInterval
    }
}



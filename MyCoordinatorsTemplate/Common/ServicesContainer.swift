//
//  ServicesContainer.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 05.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

fileprivate let services = ServicesContainer()

final class ServicesContainer {
    lazy var auth: AuthSession = { AuthSession() }()
    ///lazy var baseApiClient: ApiClient = { ApiClient() }()
}

/// List of services protocols to get needed functionality
protocol AuthSessionSupporting { }
extension AuthSessionSupporting {
    var authService: AuthSession {
        return services.auth
    }
}

///// - Api client
///protocol NetworkSupporting { }
///extension NetworkSupporting {
///    var apiClient: ApiClient  {
///        return services.baseApiClient
///     }
///}


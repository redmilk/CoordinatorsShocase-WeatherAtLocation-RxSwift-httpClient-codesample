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
    lazy var session: UserSession = { UserSession() }()
}

/// List of services protocols to get needed functionality.
/// Another way of passing dependencies - we do decorate entities by
/// adopting to empty specific services protocols.
/// By doing this way we avoid codegen in initializers

protocol Sessionable { }
extension Sessionable {
    var auth: UserSession {
        return services.session
    }
}

// example
///// - Api client
///protocol NetworkSupporting { }
///extension NetworkSupporting {
///    var apiClient: ApiClient  {
///        return services.baseApiClient
///     }
///}


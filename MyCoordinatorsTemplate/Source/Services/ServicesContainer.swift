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
    lazy var baseApiClient: ApiClient = { ApiClient() }()
    lazy var weatherApi: WeatherApi = { WeatherApi(requestable: ApiClient()) }()
    lazy var reachability: Reachability = { Reachability() }()
    lazy var location: LocationService = { LocationService() }()
    lazy var stateStore: StateStore = { StateStore() }()
    lazy var formatting: FormattingService = { FormattingService() }()
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


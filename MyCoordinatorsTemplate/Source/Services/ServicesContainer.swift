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
    lazy var reachability: Reachability = { Reachability() }()
    lazy var location: LocationService = { LocationService() }()
    lazy var stateStorage: GlobalStateStorage = { GlobalStateStorage() }()
    lazy var formatting: FormattingService = { FormattingService() }()
    
    lazy var weatherService: WeatherService = {
        let baseApi = BaseNetworkClient()
        let weatherApi = WeatherApi(baseApi: baseApi,
                                    reachability: reachability)
        return WeatherService(weatherApi: weatherApi,
                              location: location)
    }()

}

/// List of service-protocols to get needed capability.
/// Just like a way of passing dependencies. We decorate entities by
/// adopting to specific services protocols which already has internal implementation
/// by doing so we avoid codegen in initializers
/// also it's clear what functionality inside given object

/// - Storage of application scene states
protocol StateStorageAccassible { }
extension StateStorageAccassible {
    var stateStorage: GlobalStateStorage {
        return services.stateStorage
    }
}

/// - User session
protocol WeatherServiceAccassible { }
extension WeatherServiceAccassible {
    var weatherService: WeatherService {
        return services.weatherService
    }
}

/// - User session
protocol Sessionable { }
extension Sessionable {
    var auth: UserSession {
        return services.session
    }
}

/// - Location service
protocol LocationSupporting { }
extension LocationSupporting {
    var locationService: LocationService {
        return services.location
    }
}

/// - Reachability
protocol ReachabilitySupporting { }
extension ReachabilitySupporting {
    var reachability: Reachability {
        return services.reachability
    }
}

/// - Formatting
protocol Formatting { }
extension Formatting {
    var formatting: FormattingService {
        return services.formatting
    }
}


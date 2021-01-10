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

/// List of services protocols to get needed functionality
protocol Sessionable { }
extension Sessionable {
    var auth: UserSession {
        return services.session
    }
}

///// - Api client
///protocol NetworkSupporting { }
///extension NetworkSupporting {
///    var apiClient: ApiClient  {
///        return services.baseApiClient
///     }
///}


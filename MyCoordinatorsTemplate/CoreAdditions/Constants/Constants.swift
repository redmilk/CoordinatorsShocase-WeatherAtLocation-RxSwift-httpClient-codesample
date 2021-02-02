//
//  Constants.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 02.02.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

struct Constants {
    
    static let weatherKeyPlistName: String = "WeatherPublicApiKeyHide"
    static let weatherKeyName: String = "WeatherPublicApiKey"
    static var weatherApiKey: String {
        return Utils.weatherApiKey
    }

    private init() {}
}

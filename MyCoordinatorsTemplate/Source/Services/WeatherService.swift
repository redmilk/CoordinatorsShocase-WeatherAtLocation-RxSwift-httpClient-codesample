//
//  WeatherService.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 24.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

class WeatherService {
    
    let weatherApi: WeatherApiType
    
    init(weatherApi: WeatherApiType) {
        self.weatherApi = weatherApi
    }
}

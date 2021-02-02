//
//  FeedViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 04.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol WeatherLobbyViewModelProtocol {
    func pushWeather()
    func presentWeather()
}

struct WeatherLobbyViewModel: WeatherLobbyViewModelProtocol {
    
    let coordinator: WeatherCoordinatorProtocol
    let vcTitle: String
    
    init(coordinator: WeatherCoordinatorProtocol, vcTitle: String) {
        self.coordinator = coordinator
        self.vcTitle = vcTitle
    }
    
    func pushWeather() {
        coordinator.presentWeather()
    }

    func presentWeather() {
        coordinator.pushWeather()
    }
    
}

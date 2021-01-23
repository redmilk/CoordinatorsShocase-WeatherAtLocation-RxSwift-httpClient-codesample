//
//  FeedViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 04.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol FeedViewModelProtocol {
    func pushWeather()
    func presentWeather()
}

struct FeedViewModel: FeedViewModelProtocol {
    
    let coordinator: FeedCoordinatorProtocol
    let vcTitle: String
    
    init(coordinator: FeedCoordinatorProtocol, vcTitle: String) {
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

//
//  HomeViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 03.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol {
    func displayAuth()
    func pushProfile()
    func presentProfile()
}

struct HomeViewModel: HomeViewModelProtocol {
    
    let coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    func displayAuth() {
        coordinator.displayAuthAsRoot()
    }
    
    func pushProfile() {
        coordinator.pushProfile()
    }
    
    func presentProfile() {
        coordinator.presentProfile()
    }
    
}

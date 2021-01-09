//
//  HomeViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 03.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol {
    func pushProfile()
    func presentProfile()
}

struct HomeViewModel: HomeViewModelProtocol {
    
    let coordinator: HomeCoordinatorProtocol
    
    init(coordinator: HomeCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func pushProfile() {
        coordinator.pushProfile()
    }
    
    func presentProfile() {
        coordinator.presentProfile()
    }
}

//
//  MainTabBarViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 03.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

struct MainTabBarViewModel {
    
    var coordinator: MainTabBarCoordinator
    
    init(coordinator: MainTabBarCoordinator) {
        self.coordinator = coordinator
    }
    
}

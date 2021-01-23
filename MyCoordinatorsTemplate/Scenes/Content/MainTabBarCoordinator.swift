//
//  ContentCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 24.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// Coordinator for tab bar content
final class MainTabBarCoordinator: Coordinator {
        
    init(window: UIWindow,
         parentCoordinator: CoordinatorProtocol
    ) {
        super.init()
        self.window = window
        self.parentCoordinator = parentCoordinator
    }
    
    override func start() {
        let tabBarViewModel = MainTabBarViewModel(coordinator: self)
        let tabBarController = MainTabBarController.instantiate(storyboard: .content,
                                                                          instantiation: .initial) {
            return MainTabBarController(viewModel: tabBarViewModel, coder: $0)!
        }
        window.rootViewController = tabBarController
        window.becomeKey()
        self.tabBarController = tabBarController
        
        /// tab bar's first controller coordinator
        let homeCoordinator = HomeCoordinator(tabBarController: tabBarController,
                                              parentCoordinator: self,
                                              title: "Coordinator demo")
        /// tab bar's second controller coordinatorr
        let weatherCoordinator = WeatherCoordinator(tabBarController: tabBarController,
                                                    title: "Weather lobby")
        
        addChild(homeCoordinator)
        addChild(weatherCoordinator)

        homeCoordinator.start()
        weatherCoordinator.start()        
    }
    
}

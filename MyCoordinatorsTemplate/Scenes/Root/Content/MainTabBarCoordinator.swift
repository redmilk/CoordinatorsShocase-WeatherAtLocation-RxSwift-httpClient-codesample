//
//  ContentCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 24.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// Coordinator for tab bar content
final class MainTabBarCoordinator: BaseCoordinator {
        
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
                                              title: "Home")
        /// tab bar's second controller coordinator
        let feedCoordinator = FeedCoordinator(tabBarController: tabBarController, title: "Feed")
        
        addChild(homeCoordinator)
        addChild(feedCoordinator)

        homeCoordinator.start()
        feedCoordinator.start()        
    }
    
}

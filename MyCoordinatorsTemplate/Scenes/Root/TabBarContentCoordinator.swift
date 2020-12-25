//
//  ContentCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 24.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol TabBarContentCoordinatorDelegate: class {
    func displayAuth(_ coordinator: TabBarContentCoordinator)
}

/// Coordinator for tab bar content
class TabBarContentCoordinator: Coordinator {
    
    weak var delegate: TabBarContentCoordinatorDelegate!
    
    init(window: UIWindow,
         parentCoordinator: CoordinatorProtocol,
         delegate: TabBarContentCoordinatorDelegate
    ) {
        self.delegate = delegate
        super.init()
        self.window = window
        self.parentCoordinator = parentCoordinator
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: Storyboard.content.rawValue, bundle: nil)
        let tabBarController = storyboard.instantiateInitialViewController() as! MainTabBarController
        tabBarController.coordinator = self
        window.rootViewController = tabBarController
        
        /// tab bar's first controller coordinator
        let homeCoordinator = HomeCoordinator(tabBarController: tabBarController, delegate: self, title: "Home")
        /// tab bar's second controller coordinator
        let feedCoordinator = FeedCoordinator(tabBarController: tabBarController, title: "Feed")
        
        childCoordinators.append(homeCoordinator)
        childCoordinators.append(feedCoordinator)
        
        homeCoordinator.start()
        feedCoordinator.start()
    }
    
}

extension TabBarContentCoordinator: HomeCoordinatorDelegate {
    func didLogOut(_ coordinator: CoordinatorProtocol) {
        /// remove both HomeCoordinator and FeedCoordinator
        /// this classes don't need to implement ParentCoordinatable
        /// we remove them manually by this method call
        childCoordinators.removeAll()
        delegate?.displayAuth(self)
    }
}

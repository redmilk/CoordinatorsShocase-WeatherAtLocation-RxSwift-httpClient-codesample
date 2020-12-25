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
class TabBarContentCoordinator: Coordinatable {
    
    var tabBar: UITabBarController!
    weak var delegate: TabBarContentCoordinatorDelegate!
    var window: UIWindow?
    var navigationController: UINavigationController!
    weak var parentCoordinator: Coordinatable!
    var childCoordinators: [Coordinatable] = []
    
    init(window: UIWindow,
         parentCoordinator: Coordinatable,
         delegate: TabBarContentCoordinatorDelegate
    ) {
        self.window = window
        self.parentCoordinator = parentCoordinator
        self.delegate = delegate
        Logger.initialization(entity: self)
    }
    
    deinit {
        Logger.deinitialization(entity: self)
    }
    
    func start() {
        let storyboard = UIStoryboard(name: Storyboard.content.rawValue, bundle: nil)
        let tabBar = storyboard.instantiateInitialViewController() as! MainTabBarController
        tabBar.coordinator = self
        window!.rootViewController = tabBar
        
        /// tab bar's first controller coordinator
        let homeCoordinator = HomeCoordinator(tabBar: tabBar, delegate: self, title: "Home")
        /// tab bar's second controller coordinator
        let feedCoordinator = FeedCoordinator(tabBar: tabBar, title: "Feed")
        
        childCoordinators.append(homeCoordinator)
        childCoordinators.append(feedCoordinator)
        
        homeCoordinator.start()
        feedCoordinator.start()
    }
    
    func end() {
        
    }
    
}

extension TabBarContentCoordinator: HomeCoordinatorDelegate {
    func didLogOut(_ coordinator: Coordinatable) {
        /// remove both HomeCoordinator and FeedCoordinator
        /// this classes don't need to implement ParentCoordinatable
        /// we remove them manually by this method call
        childCoordinators.removeAll()
        delegate?.displayAuth(self)
    }
}

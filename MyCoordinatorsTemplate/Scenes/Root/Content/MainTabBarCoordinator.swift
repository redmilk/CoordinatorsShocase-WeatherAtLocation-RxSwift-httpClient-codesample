//
//  ContentCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 24.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol MainTabBarCoordinatorDelegate: class {
    func displayAuth(_ coordinator: MainTabBarCoordinator)
}

/// Coordinator for tab bar content
final class MainTabBarCoordinator: BaseCoordinator {
    
    weak var delegate: MainTabBarCoordinatorDelegate!
    
    init(window: UIWindow,
         parentCoordinator: CoordinatorProtocol,
         delegate: MainTabBarCoordinatorDelegate
    ) {
        self.delegate = delegate
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
        self.tabBarController = tabBarController
        
        /// tab bar's first controller coordinator
        let homeCoordinator = HomeCoordinator(tabBarController: tabBarController, delegate: self, title: "Home")
        /// tab bar's second controller coordinator
        let feedCoordinator = FeedCoordinator(tabBarController: tabBarController, title: "Feed")
        
        childCoordinators.append(homeCoordinator)
        childCoordinators.append(feedCoordinator)
        
        homeCoordinator.start()
        feedCoordinator.start()
        
        assignNavigationDelegates()
    }
    
}

extension MainTabBarCoordinator: HomeCoordinatorDelegate {
    func didLogOut(_ coordinator: CoordinatorProtocol) {
        /// removes both HomeCoordinator and FeedCoordinator
        /// this classes (HomeCoordinator and FeedCoordinator which are TabBar members)
        /// don't need to call removeChild(_ child:) on their own
        /// and we can not remove them both one by one
        /// because only one of them signals for changing the root
        /// in our case it is done for closing content and displaying auth flow
        /// we remove them all manually by this method call
        childCoordinators.removeAll()
        delegate?.displayAuth(self)
    }
}

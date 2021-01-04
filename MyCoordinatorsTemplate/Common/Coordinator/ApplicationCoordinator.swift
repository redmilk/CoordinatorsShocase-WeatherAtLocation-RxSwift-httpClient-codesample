//
//  ApplicationCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 23.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// Pseudo user session
var isLoggedIn: Bool = false

final class ApplicationCoordinator: BaseCoordinator {
        
    init(window: UIWindow) {
        super.init()
        self.window = window
    }
    
   override func start() {
        isLoggedIn ? showContent() : showAuth()
        assignNavigationDelegates()
    }
    
    private func showContent() {
        childCoordinators.forEach { (coordinator) in
            print(coordinator)
        }
        let mainTabBarCoordinator = MainTabBarCoordinator(window: window, parentCoordinator: self, delegate: self)
        childCoordinators.append(mainTabBarCoordinator)
        mainTabBarCoordinator.start()
    }
    
    private func showAuth() {
        childCoordinators.forEach { (coordinator) in
            print(coordinator)
        }
        let child = AuthCoordinator(title: "Auth",
                                    window: window,
                                    parentCoordinator: self,
                                    delegate: self)
        childCoordinators.append(child)
        child.start()
    }
}

// MARK: - Authenticate flow delegate for log in
extension ApplicationCoordinator: AuthCoordinatorDelegate {
    func didAuthenticate(_ coordinator: AuthCoordinator) {
        start()
    }
}

// MARK: - TabBarContent delegate for log out
extension ApplicationCoordinator: MainTabBarCoordinatorDelegate {
    func displayAuth(_ coordinator: MainTabBarCoordinator) {
        childCoordinators.removeAll()
        start()
    }
}

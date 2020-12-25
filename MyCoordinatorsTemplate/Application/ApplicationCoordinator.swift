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
    }
    
    private func showContent() {
        childCoordinators.forEach { (coordinator) in
            print(coordinator)
        }
        let child = TabBarContentCoordinator(window: window, parentCoordinator: self, delegate: self)
        childCoordinators.append(child)
        child.start()
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
extension ApplicationCoordinator: TabBarContentCoordinatorDelegate {
    func displayAuth(_ coordinator: TabBarContentCoordinator) {
        childCoordinators.removeAll()
        start()
    }
}

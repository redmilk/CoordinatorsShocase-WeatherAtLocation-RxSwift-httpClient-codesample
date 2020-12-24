//
//  ApplicationCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 23.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// Change it to see auth or content
var isLoggedIn: Bool = false

class ApplicationCoordinator: CoordinatorProtocol, Rootable, ChildCoordinatable {
    
    var window: UIWindow
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        isLoggedIn ? showContent() : showAuth()
    }
    
    private func showContent() {
        let child = TabBarContentCoordinator(window: window, parentCoordinator: self, delegate: self)
        childCoordinators.append(child)
        child.start()
    }
    
    private func showAuth() {
        let child = AuthCoordinator(title: "Auth",
                                    window: window,
                                    parent: self,
                                    delegate: self)
        childCoordinators.append(child)
        child.start()
    }
}

// MARK: - Authenticate flow delegate for log in
extension ApplicationCoordinator: AuthCoordinatorDelegate {
    func didAuthenticate(_ coordinator: AuthCoordinator) {
        showContent()
        removeChild(coordinator)
    }
}

// MARK: - TabBarContent delegate for log out
extension ApplicationCoordinator: TabBarContentCoordinatorDelegate {
    func displayAuth(_ coordinator: CoordinatorProtocol) {
        removeChild(coordinator)
        //showAuth()
        start()
    }
}

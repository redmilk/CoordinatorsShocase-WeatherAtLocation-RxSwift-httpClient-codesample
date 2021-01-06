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

final class ApplicationCoordinator: BaseCoordinator, AuthSessionSupporting {
        
    init(window: UIWindow) {
        super.init()
        self.window = window
    }
    
   override func start() {
        isLoggedIn ? showContent() : showAuth()
    }
    
    private func showContent() {
        let mainTabBarCoordinator = MainTabBarCoordinator(window: window, parentCoordinator: self, delegate: self)
        addChild(mainTabBarCoordinator)
        mainTabBarCoordinator.start()
    }
    
    private func showAuth() {
        let child = AuthCoordinator(title: "Authentication",
                                    presentationMode: .root(window),
                                    parentCoordinator: self,
                                    delegate: self)
        addChild(child)
        child.start()
    }
}

// MARK: - Authenticate flow delegate for log in
extension ApplicationCoordinator: AuthCoordinatorDelegate {
    func authFlowDidFinish(_ coordinator: AuthCoordinator) {
        start()
    }
}

// MARK: - TabBarContent delegate for log out
extension ApplicationCoordinator: MainTabBarCoordinatorDelegate {
    func displayAuth(_ coordinator: MainTabBarCoordinator) {
        removeAllChildCoordinators()
        start()
    }
}

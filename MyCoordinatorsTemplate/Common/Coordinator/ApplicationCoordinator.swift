//
//  ApplicationCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 23.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

// MARK: - Capabilities
extension ApplicationCoordinator: AuthSessionSupporting { }


final class ApplicationCoordinator: BaseCoordinator {
        
    init(window: UIWindow) {
        super.init()
        self.window = window
    }
    
    override func start() {
        authService.subscribeToUserChanges { [unowned(unsafe) self] (user) in /// this object will live during the app's life
            self.authService.isAuthorized ? self.showContent() : self.showAuth()
        }
        authService.isAuthorized ? self.showContent() : self.showAuth()
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

//
//  ApplicationCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 23.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

// MARK: - Capabilities
extension ApplicationCoordinator: Sessionable { }

/// this object will live during the app's life
final class ApplicationCoordinator: BaseCoordinator {
        
    init(window: UIWindow) {
        super.init()
        self.window = window
    }
    
    override func start() {
        auth.isAuthorized ? self.showContent() : self.showAuth()
        
        /// drive application auth logic, if current user is nil - run login flow
        auth.subscribeToUserChanges { [unowned(unsafe) self] (user) in
            self.removeAllChildCoordinators()
            self.auth.isAuthorized ? self.showContent() : self.showAuth()
        }
    }
    
    private func showContent() {
        let mainTabBarCoordinator = MainTabBarCoordinator(window: window,
                                                          parentCoordinator: self)
        addChild(mainTabBarCoordinator)
        mainTabBarCoordinator.start()
    }
    
    private func showAuth() {
        let child = AuthCoordinator(title: "Authentication",
                                    presentationMode: .root(window),
                                    parentCoordinator: self)
        addChild(child)
        child.start()
    }
}

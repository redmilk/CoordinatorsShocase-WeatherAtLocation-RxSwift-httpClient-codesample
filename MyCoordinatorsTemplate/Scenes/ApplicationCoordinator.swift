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

/// main coordination model, decides which screen to open first
final class ApplicationCoordinator: Coordinator {
        
    init(window: UIWindow) {
        super.init()
        self.window = window
    }
    
    override func start() {
        auth.isAuthorized ? self.showContent() : self.showAuth()
        
        /// drives application auth logic, whether current user is nil it shows auth flow
        auth.subscribeToUserChanges { [unowned(unsafe) self] (user) in
            self.clear()
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

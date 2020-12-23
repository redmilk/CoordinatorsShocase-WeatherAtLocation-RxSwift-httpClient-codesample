//
//  ApplicationCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 23.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// Change it to see auth or content
let isLoggedIn: Bool = false


class ApplicationCoordinator: Coordinatable {
    
    var window: UIWindow!
    
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinatable] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        if isLoggedIn {
            let storyboard = UIStoryboard(name: Storyboard.content.rawValue, bundle: nil)
            let tabBarController = storyboard.instantiateInitialViewController() as! MainTabBarController
            window.rootViewController = tabBarController
        } else {
            let storyboard = UIStoryboard(name: Storyboard.auth.rawValue, bundle: nil)
            let navigation = storyboard.instantiateInitialViewController() as! UINavigationController
            let auth = navigation.viewControllers.first as! AuthViewController
            auth.title = "Auth"
            window.rootViewController = navigation
        }
    }
    
    func end() {
        
    }
}

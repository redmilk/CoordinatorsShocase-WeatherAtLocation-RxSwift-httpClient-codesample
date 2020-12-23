//
//  MainTabBarController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeNav = UINavigationController()
        homeNav.navigationBar.barTintColor = .cyan
        
        let feedNav = UINavigationController()
        feedNav.navigationBar.barTintColor = .green
        
        let home = HomeCoordinator(navigation: homeNav, title: "Home")
        let feed = FeedCoordinator(navigation: feedNav, title: "Feed")
        
        home.start()
        feed.start()
        
        guard
            let homeNavigation = home.navigationController,
            let feedNavigation = feed.navigationController else { return }
        
        viewControllers = [homeNavigation, feedNavigation]
    }

}

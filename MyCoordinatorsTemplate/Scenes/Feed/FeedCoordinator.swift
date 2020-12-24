//
//  FeedCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class FeedCoordinator: CoordinatorProtocol, NavigationControllable, TabBarControllable {
    
    var tabBar: UITabBarController!
    var navigationController: UINavigationController!
    
    private let title: String
    
    init(tabBar: UITabBarController,
         title: String
    ) {
        self.tabBar = tabBar
        self.title = title
    }
    
    func start() {
        let storyboard = UIStoryboard(name: Storyboard.feed.rawValue, bundle: nil)
        navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        navigationController.tabBarItem = UITabBarItem(title: "Feed", image: nil, selectedImage: nil)
        let controller = navigationController.viewControllers.first as! FeedViewController
        controller.title = title
        tabBar.viewControllers?.append(navigationController)
    }
    
}

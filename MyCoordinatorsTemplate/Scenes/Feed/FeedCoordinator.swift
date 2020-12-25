//
//  FeedCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// TabBarContentCoordinator on start fills array of child with both Home and Feed coordinators
/// We don't have to implement ParentCoordinatable here and inside HomeCoordinator
/// due to removing all children with removeAll on LogOut inside TabBarContentCoordinator

class FeedCoordinator: Coordinator {
    
    weak var tabBar: UITabBarController!
    private let title: String
    
    init(tabBar: UITabBarController,
         title: String
    ) {
        self.tabBar = tabBar
        self.title = title
        super.init()
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: Storyboard.feed.rawValue, bundle: nil)
        navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        navigationController.tabBarItem = UITabBarItem(title: "Feed", image: nil, selectedImage: nil)
        let controller = navigationController.viewControllers.first as! FeedViewController
        controller.title = title
        tabBar.viewControllers?.append(navigationController)
    }
    
}

//
//  FeedCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// TabBarContentCoordinator on start fills array of child with both Home and Feed coordinators

final class FeedCoordinator: BaseCoordinator {
    
    private let title: String
    
    init(tabBarController: UITabBarController,
         title: String
    ) {
        self.title = title
        super.init()
        self.tabBarController = tabBarController
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: Storyboard.feed.rawValue, bundle: nil)
        navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        
        guard
            let navigationController = navigationController
            else { fatalError("internal inconsistency") }
        
        navigationController.tabBarItem = UITabBarItem(title: "Feed", image: nil, selectedImage: nil)
        let controller = navigationController.viewControllers.first as! FeedViewController
        controller.title = title
        controller.coordinator = self
        
        guard
            let tabBarController = tabBarController
            else { fatalError("internal inconsistency") }
        
        tabBarController.addControllerForTab(navigationController)
        assignNavigationDelegates()
    }
    
    func displayDetail() {
        let controller = DetailViewController.instantiate(storyboardName: .feed)
        controller.coordinator = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func displayDraggable() {
        let vc = FeedCustomViewController()
        navigationController?.present(vc, animated: true)
    }
    
}


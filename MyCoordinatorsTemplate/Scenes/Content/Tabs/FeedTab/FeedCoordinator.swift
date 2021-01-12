//
//  FeedCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol FeedCoordinatorProtocol {
    func pushDetail()
    func presentNoStoryboardedVC()
}

/// MainTabBarCoordinator on start fills array of child with both Home and Feed coordinators
final class FeedCoordinator: Coordinator, FeedCoordinatorProtocol {
    
    private let vcTitle: String
    
    init(tabBarController: UITabBarController,
         title: String
    ) {
        self.vcTitle = title
        super.init()
        self.tabBarController = tabBarController
    }
    
    override func start() {
        let viewModel = FeedViewModel(coordinator: self, vcTitle: "Feed")
        let controller = FeedViewController.instantiate(storyboard: .feed, instantiation: .initial) {
            return FeedViewController(viewModel: viewModel, coder: $0)!
        }
        navigationController = NavigationControllerFactory.makeStyled(style: .feed, root: controller)
        navigationController?.tabBarItem = UITabBarItem(title: "Feed", image: nil, selectedImage: nil)
        tabBarController?.addControllerForTab(navigationController!)
    }
    
    func pushDetail() {
        let viewModel = WeatherViewModel(coordinator: self, vcTitle: "Weather screen")
        let controller = WeatherViewController.instantiate(storyboard: .feed,
                                                          instantiation: .withIdentifier) {
            return WeatherViewController(viewModel: viewModel, coder: $0)!
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func presentNoStoryboardedVC() {
        let viewModel = MainSceneReducer()
        let controller = MainSceneViewController.instantiate(storyboard: .feed, instantiation: .withIdentifier) {
            MainSceneViewController(viewModel: viewModel, coder: $0)!
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
}


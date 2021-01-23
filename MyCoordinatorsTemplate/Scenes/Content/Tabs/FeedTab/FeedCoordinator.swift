//
//  FeedCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol FeedCoordinatorProtocol {
    func presentWeather()
    func pushWeather()
}

/// MainTabBarCoordinator on start fills array of child with both Home and Weather coordinators
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
        let viewModel = FeedViewModel(coordinator: self, vcTitle: "Weather")
        let controller = FeedViewController.instantiate(storyboard: .weather, instantiation: .initial) {
            return FeedViewController(viewModel: viewModel, coder: $0)!
        }
        navigationController = NavigationControllerFactory.makeStyled(style: .weather, root: controller)
        navigationController?.tabBarItem = UITabBarItem(title: "Weather", image: nil, selectedImage: nil)
        tabBarController?.addControllerForTab(navigationController!)
    }
    
    func presentWeather() {
        let viewModel = WeatherSceneViewModel()
        var controller = WeatherSceneViewController.instantiate(storyboard: .weather, instantiation: .withIdentifier) {
            WeatherSceneViewController(viewModel: viewModel, coder: $0)!
        }
        controller.bindViewModel(to: viewModel)
        navigationController?.present(controller, animated: isAnimatedTransition, completion: nil)
    }
    
    func pushWeather() {
        let viewModel = WeatherSceneViewModel()
        var controller = WeatherSceneViewController.instantiate(storyboard: .weather, instantiation: .withIdentifier) {
            WeatherSceneViewController(viewModel: viewModel, coder: $0)!
        }
        controller.bindViewModel(to: viewModel)
        navigationController?.pushViewController(controller, animated: isAnimatedTransition)
    }
    
}


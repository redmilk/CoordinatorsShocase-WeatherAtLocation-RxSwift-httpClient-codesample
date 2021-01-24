//
//  FeedCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit
import RxSwift

protocol WeatherCoordinatorProtocol {
    func presentWeather()
    func pushWeather()
}

/// MainTabBarCoordinator on start fills array of child with both Home and Weather coordinators
final class WeatherCoordinator: Coordinator, WeatherCoordinatorProtocol, StateStorageAccassible {
    
    private let vcTitle: String
    
    init(tabBarController: UITabBarController,
         title: String
    ) {
        self.vcTitle = title
        super.init()
        self.tabBarController = tabBarController
    }
    
    override func start() {
        let viewModel = WeatherLobbyViewModel(coordinator: self, vcTitle: vcTitle)
        let controller = WeatherLobbyController.instantiate(storyboard: .weather, instantiation: .initial) {
            return WeatherLobbyController(viewModel: viewModel, coder: $0)!
        }
        navigationController = NavigationControllerFactory.makeStyled(style: .weather, root: controller)
        navigationController?.tabBarItem = UITabBarItem(title: "Weather", image: nil, selectedImage: nil)
        tabBarController?.addControllerForTab(navigationController!)
    }
    
    func presentWeather() {
        let viewModel = WeatherSceneViewModel(coordinator: self)
        var controller = WeatherSceneViewController.instantiate(storyboard: .weather, instantiation: .withIdentifier) {
            WeatherSceneViewController(viewModel: viewModel, stateStorage: self.store, coder: $0)!
        }
        controller.bindViewModel(to: viewModel)
        currentController = controller
        navigationController?.present(controller, animated: isAnimatedTransition, completion: nil)
    }
     
    func pushWeather() {
        let viewModel = WeatherSceneViewModel(coordinator: self)
        var controller = WeatherSceneViewController.instantiate(storyboard: .weather, instantiation: .withIdentifier) {
            WeatherSceneViewController(viewModel: viewModel, stateStorage: self.store, coder: $0)!
        }
        controller.bindViewModel(to: viewModel)
        currentController = controller
        navigationController?.pushViewController(controller, animated: isAnimatedTransition)
    }
    
    func displayAlert(errorData: (msg: String, title: String), bag: DisposeBag) {
        switch errorData.title {
        case "No location access":
            currentController?.present(alertWithActionAndText: errorData.msg,
                                       title: "Go to Settings",
                                       actionTitle: errorData.title) { [weak self] in
                self?.displayApplicationSettings()
            }
            .subscribe(on: MainScheduler.instance)
            .subscribe()
            .disposed(by: bag)
        case _:
            currentController?.present(simpleAlertWithText: errorData.msg,
                                       title: errorData.title)
                .subscribe(on: MainScheduler.instance)
                .subscribe()
                .disposed(by: bag)
        }
    }
    
    func displayApplicationSettings() {
        Utils.openSettings()
    }
    
}


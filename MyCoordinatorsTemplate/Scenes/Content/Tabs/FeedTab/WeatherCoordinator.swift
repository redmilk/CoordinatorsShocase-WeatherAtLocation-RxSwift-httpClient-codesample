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
final class WeatherCoordinator: Coordinator,
                                WeatherCoordinatorProtocol,
                                StateStorageAccassible,
                                WeatherServiceAccassible {
    
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
        let viewModel = WeatherSceneViewModel(coordinator: self, weatherService: weatherService, stateStorageWriter: stateStorage)
        var controller = WeatherSceneViewController.instantiate(storyboard: .weather, instantiation: .withIdentifier) {
            WeatherSceneViewController(viewModel: viewModel, stateStorageReader: self.stateStorage, coder: $0)!
        }
        controller.bindViewModel(to: viewModel)
        currentController = controller
        navigationController?.present(controller, animated: isAnimatedTransition, completion: nil)
    }
     
    func pushWeather() {
        let viewModel = WeatherSceneViewModel(coordinator: self, weatherService: weatherService, stateStorageWriter: stateStorage)
        var controller = WeatherSceneViewController.instantiate(storyboard: .weather, instantiation: .withIdentifier) {
            WeatherSceneViewController(viewModel: viewModel, stateStorageReader: self.stateStorage, coder: $0)!
        }
        controller.bindViewModel(to: viewModel)
        currentController = controller
        navigationController?.pushViewController(controller, animated: isAnimatedTransition)
    }
    
    func displayAlert(error: ApplicationError, bag: DisposeBag) {
        guard let errorContent = error.errorContent else { fatalError("Internal inconsistency") }
        switch error.errorType {
        case .noLocationPermission:
            currentController?.present(alertWithActionAndText: errorContent.message,
                                       title: "Go to Settings",
                                       actionTitle: errorContent.title) { [weak self] in
                self?.displayApplicationSettings()
            }
            .subscribe(on: MainScheduler.instance)
            .subscribe()
            .disposed(by: bag)
        case _:
            currentController?.present(simpleAlertWithText: errorContent.message,
                                       title: errorContent.title)
                .subscribe(on: MainScheduler.instance)
                .subscribe()
                .disposed(by: bag)
        }
    }
    
    func displayApplicationSettings() {
        Utils.openSettings()
    }
    
}


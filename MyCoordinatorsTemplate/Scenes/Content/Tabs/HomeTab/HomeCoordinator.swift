//
//  HomeCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol HomeCoordinatorProtocol {
    func pushProfile()
    func presentProfile()
}

final class HomeCoordinator: Coordinator, HomeCoordinatorProtocol {
        
    private let title: String
    
    init(tabBarController: UITabBarController,
         parentCoordinator: CoordinatorProtocol,
         title: String
    ) {
        self.title = title
        super.init()
        self.tabBarController = tabBarController
        self.parentCoordinator = parentCoordinator
    }
    
    override func start() {
        let homeViewModel = HomeViewModel(coordinator: self)
        let homeVewController = HomeViewController.instantiate(storyboard: .home, instantiation: .initial) {
            return  HomeViewController(title: "Home", viewModel: homeViewModel, coder: $0)!
        }
        let navigationController = NavigationControllerFactory.makeStyled(style: .home, root: homeVewController)
        
        guard
            let tabBarController = tabBarController
            else { fatalError("internal inconsistency") }
        
        tabBarController.addControllerForTab(navigationController)
        self.navigationController = navigationController
    }
    
    // MARK: - Display profile scene
    func pushProfile() {
        let child = ProfileCoordinator(parentCoordinator: self,
                                       title: "Profile",
                                       presentationType: .push(navigationController!))
        addChild(child)
        child.start()
    }
    
    func presentProfile() {
        let child = ProfileCoordinator(parentCoordinator: self,
                                       title: "Profile",
                                       presentationType: .modal(navigationController!))
        addChild(child)
        child.start()
    }
    
}

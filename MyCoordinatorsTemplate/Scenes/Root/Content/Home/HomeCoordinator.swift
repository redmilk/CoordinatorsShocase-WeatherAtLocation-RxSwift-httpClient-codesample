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
    func displayAuthAsRoot()
}

protocol HomeCoordinatorDelegate: class {
    func didLogOut(_ coordinator: CoordinatorProtocol)
}

final class HomeCoordinator: BaseCoordinator, HomeCoordinatorProtocol {
    
    weak var delegate: HomeCoordinatorDelegate?
    
    private let title: String
    
    init(tabBarController: UITabBarController,
         delegate: HomeCoordinatorDelegate,
         title: String
    ) {
        self.delegate = delegate
        self.title = title
        super.init()
        self.tabBarController = tabBarController
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: Storyboard.home.rawValue, bundle: nil)
        let homeViewModel = HomeViewModel(coordinator: self)
        let homeVewController: HomeViewController! = storyboard.instantiateInitialViewController {
            HomeViewController(title: "Home", viewModel: homeViewModel, coder: $0)
        }
        let navigationController = UINavigationController.styledNavigation(homeVewController, style: .blue)
        
        guard
            let tabBarController = tabBarController
            else { fatalError("internal inconsistency") }
        
        tabBarController.addControllerForTab(navigationController)
        self.navigationController = navigationController
        assignNavigationDelegates()
    }
    
    // MARK: - Display profile scene
    func pushProfile() {
        guard let navigation = navigationController else { return }
        let child = ProfileCoordinator(parentCoordinator: self,
                                       title: "Profile",
                                       presentationType: .push(navigation))
        childCoordinators.append(child)
        child.start()
    }
    
    func presentProfile() {
        let child = ProfileCoordinator(parentCoordinator: self,
                                       title: "Profile",
                                       presentationType: .modal)
        childCoordinators.append(child)
        child.start()        
    }
    
    func displayAuthAsRoot() {
        delegate?.didLogOut(self)
    }
    
}

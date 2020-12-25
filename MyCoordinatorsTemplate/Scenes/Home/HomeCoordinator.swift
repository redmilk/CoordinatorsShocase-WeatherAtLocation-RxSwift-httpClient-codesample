//
//  HomeCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol ProfileCoordinating {
    func pushProfile()
    func presentProfile()
}

protocol HomeCoordinatorDelegate: class {
    func didLogOut(_ coordinator: CoordinatorProtocol)
}

class HomeCoordinator: Coordinator {
    
    weak var delegate: HomeCoordinatorDelegate?
    weak var tabBar: UITabBarController!
    
    private let title: String
    
    init(tabBar: UITabBarController,
         delegate: HomeCoordinatorDelegate,
         title: String
    ) {
        self.delegate = delegate
        self.tabBar = tabBar
        self.title = title
        super.init()
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: Storyboard.home.rawValue, bundle: nil)
        navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        navigationController.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
        let controller = navigationController.viewControllers.first as! HomeViewController
        controller.title = title
        controller.coordinator = self
        tabBar.viewControllers = [navigationController]
    }
    
    // MARK: - ProfileCoordinatable
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

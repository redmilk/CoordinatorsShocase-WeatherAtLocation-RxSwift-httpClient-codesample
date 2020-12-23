//
//  HomeCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol ProfileCoordinatable {
    func pushProfile()
    func presentProfile()
}

protocol AuthCoordinatable {
    func presentAuth()
}

class HomeCoordinator: Coordinatable, ProfileCoordinatable, AuthCoordinatable {
    
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinatable] = []
    
    private let title: String
    
    init(navigation: UINavigationController,
         title: String
    ) {
        navigationController = navigation
        self.title = title
        print("⭕️ init HomeCoordinator")
    }
    
    deinit {
        print("🚫 deinit HomeCoordinator")
    }
    
    func removeChild(_ child: Coordinatable?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
        
        print("-after-")
        print("amount of coordinators in stack: " + childCoordinators.count.description)
    }
    
    func start() {
        let controller = HomeViewController.instantiate(.home)
        controller.title = title
        controller.coordinator = self
        navigationController?.pushViewController(controller, animated: false)
        navigationController?.tabBarItem = UITabBarItem(title: title, image: nil, selectedImage: nil)
    }
    
    func end() {
        
    }
    
    // MARK: - ProfileCoordinatable
    func pushProfile() {
        guard let navigation = navigationController else { return }
        let child = ProfileCoordinator(parentCoordinator: self,
                                       title: "Profile",
                                       presentationType: .push(navigation))
        childCoordinators.append(child)
        child.start()
        
        print("-before-")
        print("amount of coordinators in stack: " + childCoordinators.count.description)
    }
    
    func presentProfile() {
        let child = ProfileCoordinator(parentCoordinator: self,
                                       title: "Profile",
                                       presentationType: .modal)
        childCoordinators.append(child)
        child.start()
        
        print("-before-")
        print("amount of coordinators in stack: " + childCoordinators.count.description)
    }

    // MARK: - AuthCoordinatable
    func presentAuth() {
        
    }
    
}

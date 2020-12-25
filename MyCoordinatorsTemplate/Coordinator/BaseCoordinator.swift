//
//  Coordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 25.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class BaseCoordinator: NSObject, CoordinatorProtocol {
        
    var window: UIWindow!
    var childCoordinators: [CoordinatorProtocol] = []
    
    weak var parentCoordinator: CoordinatorProtocol!
    weak var navigationController: UINavigationController?
    weak var tabBarController: UITabBarController?
    
    override init() {
        super.init()
        Logger.initialization(entity: self)
    }
    
    deinit {
        Logger.deinitialization(entity: self)
    }
    
    func start() {
        navigationController?.delegate = self
        tabBarController?.delegate = self
    }
    
    func end() { }
    
    func willNavigate(_ navigationController: UINavigationController,
                      to viewController: UIViewController,
                      animated: Bool) {
        Logger.log("Navigation to: ", entity: viewController)
    }
    
    func didSelect(_ tabBarController: UITabBarController,
                      tab selectedTabController: UIViewController) {
        Logger.log("Tab selected: ", entity: selectedTabController)
    }
}

// MARK: - UINavigationControllerDelegate
extension BaseCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool
    ) {
        willNavigate(navigationController,
                     to: viewController,
                     animated: animated)
    }
    
}

// MARK: - UITabBarControllerDelegate
extension BaseCoordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController
    ) {
        didSelect(tabBarController,
                  tab: viewController)
    }
    
}

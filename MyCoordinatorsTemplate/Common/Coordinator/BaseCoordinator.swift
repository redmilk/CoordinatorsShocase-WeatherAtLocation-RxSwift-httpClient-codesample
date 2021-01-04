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
    weak var navigationController: UINavigationController? {
        didSet {
            //assignNavigationDelegates()
        }
    }
    weak var tabBarController: UITabBarController? {
        didSet {
            //assignNavigationDelegates()
        }
    }
    
    override init() {
        super.init()
        //Logger.initialization(entity: self)
    }
    
    deinit {
        Logger.deinitialization(entity: self)
    }
    
    func start() { }
    func end() { }
    
    /// We call this at the end of 'start()'
    /// for enabling navigation and tabbar delegate events
    func assignNavigationDelegates() {
        navigationController?.delegate = self
        tabBarController?.delegate = self
    }
    
    func removeChild(_ child: CoordinatorProtocol) {
         for (index, coordinator) in childCoordinators.enumerated() {
             if coordinator === child {
                 childCoordinators.remove(at: index)
                 break
             }
         }
        /// Reassign navigation delegates to self when removing child coordinator
        /// otherwise current parent coordinator won't handle navigation events
        assignNavigationDelegates()
     }
    
    /// Navigation events for UINavigationController
    func didNavigate(_ navigationController: UINavigationController,
                      to viewController: UIViewController,
                      animated: Bool) {
        Logger.log("Navigation to", entity: viewController, symbol: "[STACK]")
    }
    
    /// Navigation events for UITabBarController
    func didSelect(_ tabBarController: UITabBarController,
                      tab selectedTabController: UIViewController) {
        guard
            let navigationController = selectedTabController as? UINavigationController,
            let topControllerInStack = navigationController.viewControllers.last else {
                Logger.log("Pure tab selected", entity: selectedTabController, symbol: "[PURE TAB]")
                return
        }
        Logger.log("Selected tab with navigation stack", entity: topControllerInStack, symbol: "[NAV TAB]")
    }
}

// MARK: - UINavigationControllerDelegate
extension BaseCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool
    ) {
        didNavigate(navigationController,
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

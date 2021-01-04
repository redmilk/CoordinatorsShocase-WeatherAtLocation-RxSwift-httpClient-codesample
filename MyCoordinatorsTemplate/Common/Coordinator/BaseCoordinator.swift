//
//  Coordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 25.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class BaseCoordinator: NSObject, CoordinatorProtocol {
    
    enum PresentationMode {
        case push
        case modal
    }
    
    private var childCoordinators: [String : CoordinatorProtocol] = [:]
    var window: UIWindow!
    weak var parentCoordinator: CoordinatorProtocol!
    weak var navigationController: UINavigationController? {
        didSet {
            assignNavigationDelegates()
        }
    }
    weak var tabBarController: UITabBarController? {
        didSet {
            assignNavigationDelegates()
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
    /// TODO: rename reassign
    func assignNavigationDelegates() {
        navigationController?.delegate = self
        tabBarController?.delegate = self
    }
    
    func addChild(_ child: CoordinatorProtocol) {
        let key = String(describing: child)
        childCoordinators[key] = child
    }
    
    func removeChild(_ child: CoordinatorProtocol) {
        let key = String(describing: child)
        childCoordinators.removeValue(forKey: key)
        /// Reassign navigation delegates to self when removing child coordinator
        /// otherwise current parent coordinator won't handle navigation events
        assignNavigationDelegates()
        /// TODO: check if this isn't a useless line
     }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
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

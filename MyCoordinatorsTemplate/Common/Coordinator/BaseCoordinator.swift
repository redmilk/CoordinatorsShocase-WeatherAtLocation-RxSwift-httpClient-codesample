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
        case push(UINavigationController)
        case modal(UIViewController)
        case root(UIWindow)
    }
        
    private var childCoordinators: [String : CoordinatorProtocol] = [:]
    weak var window: UIWindow!
    weak var parentCoordinator: CoordinatorProtocol?
    weak var currentController: UIViewController?
    weak var navigationController: UINavigationController? {
        didSet {
            reassignNavigationDelegates()
        }
    }
    weak var tabBarController: UITabBarController? {
        didSet {
            reassignNavigationDelegates()
        }
    }
    
    override init() {
        super.init()
        //Logger.initialization(entity: self)
    }
    
    deinit {
        Logger.deinitialization(entity: self)
    }
    
    func start() {
        
    }
    
    func end() {
        removeAllChildCoordinators()
        parentCoordinator?.removeChild(self)
        navigationController?.popToRootViewController(animated: true)
        currentController?.dismiss(animated: true, completion: nil)
    }
    
    /// We call this at the end of 'start()'
    /// for enabling navigation and tabbar delegate events
    func reassignNavigationDelegates() {
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
        reassignNavigationDelegates()
     }
    
    func removeAllChildCoordinators() {
        //childCoordinators.enumerated().forEach { $0.element.value.end() }
        childCoordinators.enumerated().forEach { $0.element.value.removeAllChildCoordinators() }
        childCoordinators.enumerated().forEach { $0.element.value.parentCoordinator?.removeChild(self) }
        childCoordinators.removeAll()
    }
    
    func collapseCoordinatorStackRecursevly() {
        if let parent = parentCoordinator {
            //print(parent)
            parent.removeAllChildCoordinators()
            parent.collapseCoordinatorStackRecursevly()
        }
    }
    
    /// Navigation events for UINavigationController
    func didNavigate(_ navigationController: UINavigationController,
                      to viewController: UIViewController,
                      animated: Bool) {
        //Logger.log("Navigated to", entity: viewController, symbol: "[STACK]")
    }
    
    /// Navigation events for UITabBarController
    func didSelect(_ tabBarController: UITabBarController,
                      tab selectedTabController: UIViewController) {
        guard
            let navigationController = selectedTabController as? UINavigationController,
            let topControllerInStack = navigationController.viewControllers.last else {
                //Logger.log("Tab selected with no navigation controller embedded", entity: selectedTabController, symbol: "[PURE TAB]")
                return
        }
        //Logger.log("Selected tab with navigation controller", entity: topControllerInStack, symbol: "[NAV TAB]")
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

//
//  Coordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 25.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class Coordinator: NSObject, CoordinatorProtocol {
        
    enum PresentationMode {
        case push(UINavigationController)
        case modal(UIViewController)
        case root(UIWindow)
    }
        
    private var childCoordinators: [String : CoordinatorProtocol] = [:]
    private(set) var isAnimatedTransition: Bool = true
    
    weak var window: UIWindow!
    weak var parentCoordinator: CoordinatorProtocol?
    weak var currentController: UIViewController?
    weak var navigationController: UINavigationController? {
        didSet {
            updateNavigationDelegates()
        }
    }
    weak var tabBarController: UITabBarController? {
        didSet {
            updateNavigationDelegates()
        }
    }
    
    override init() {
        super.init()
        Logger.initialization(entity: self)
    }
    
    deinit {
        Logger.deinitialization(entity: self)
    }
    
    func start() {
        
    }
    
    func end() {
        currentController?.dismiss(animated: false, completion: nil)
        navigationController?.popToRootViewController(animated: false)
        clear()
    }
    
    func updateNavigationDelegates() {
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
        /// otherwise current parent coordinator won't handle default OS navigation events
        updateNavigationDelegates()
     }
    
    func clear() {
        childCoordinators.enumerated().forEach { $0.element.value.clear() }
        childCoordinators.enumerated().forEach { $0.element.value.parentCoordinator?.removeChild(self) }
        childCoordinators.removeAll()
        parentCoordinator?.removeChild(self)
    }
    
    /// Navigation events for UINavigationController
    func didNavigate(_ navigationController: UINavigationController,
                      to viewController: UIViewController,
                      animated: Bool) {
        Logger.log("Navigated to", entity: viewController, symbol: "🛼 [STACK]")
        currentController = viewController
    }
    
    /// Navigation events for UITabBarController
    func didSelect(_ tabBarController: UITabBarController,
                      tab selectedTabController: UIViewController) {
        guard
            let navigationController = selectedTabController as? UINavigationController,
            let topControllerInStack = navigationController.viewControllers.last else {
                Logger.log("Tab selected with no navigation controller embedded", entity: selectedTabController, symbol: "🛼 [PURE TAB]")
                return
        }
        Logger.log("Selected tab with navigation controller", entity: topControllerInStack, symbol: "🛼 [NAV TAB]")
    }
}

///  - note: Also we can make base coordinator as generic for returning Observable values instead delegation pattern

// MARK: - UINavigationControllerDelegate
extension Coordinator: UINavigationControllerDelegate {
    
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
extension Coordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController
    ) {
        didSelect(tabBarController,
                  tab: viewController)
    }
    
}

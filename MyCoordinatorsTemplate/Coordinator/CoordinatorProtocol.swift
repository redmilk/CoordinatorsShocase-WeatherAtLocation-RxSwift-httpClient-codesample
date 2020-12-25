//
//  Coordinated.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {

    /// if current coordinator is parent for other coordinators
    var childCoordinators: [CoordinatorProtocol] { get set }
    func removeChild(_ child: CoordinatorProtocol)
    
    /// if current coordinator has parent
    var parentCoordinator: CoordinatorProtocol! { get set }
    
    /// if navigation starts from UINavigationController
    var navigationController: UINavigationController! { get set }
    
    /// if navigation starts from UITabBarController
    var tabBarController: UITabBarController! { get set }
    
    /// if coordinator can set root for application
    var window: UIWindow! { get set }
        
    func start()
    func end()

}

extension CoordinatorProtocol {
    func removeChild(_ child: CoordinatorProtocol) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

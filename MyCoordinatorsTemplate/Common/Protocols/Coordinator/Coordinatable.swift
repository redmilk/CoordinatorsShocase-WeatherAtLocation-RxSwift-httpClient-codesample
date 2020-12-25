//
//  Coordinated.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol Coordinatable: AnyObject {

    var childCoordinators: [Coordinatable] { get set }
    var window: UIWindow? { get set }
    var parentCoordinator: Coordinatable! { get set }
    var navigationController: UINavigationController! { get set }
    var tabBar: UITabBarController! { get set }
    
    func removeChild(_ child: Coordinatable?)
    
    func start()
    func end()

}

extension Coordinatable {
    func removeChild(_ child: Coordinatable?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

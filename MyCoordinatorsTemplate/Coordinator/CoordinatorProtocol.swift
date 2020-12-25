//
//  Coordinated.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {

    var childCoordinators: [CoordinatorProtocol] { get set }
    var parentCoordinator: CoordinatorProtocol! { get set }
    var navigationController: UINavigationController! { get set }
    
    func removeChild(_ child: CoordinatorProtocol)
    
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

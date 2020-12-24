//
//  HasChildCoordinators.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 23.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol ChildCoordinatable where Self: CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] { get set }
    func removeChild(_ child: CoordinatorProtocol?)
}

extension ChildCoordinatable {
    func removeChild(_ child: CoordinatorProtocol?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

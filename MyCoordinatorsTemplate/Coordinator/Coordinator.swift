//
//  Coordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 25.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class Coordinator: NSObject, CoordinatorProtocol {
        
    var window: UIWindow!
    var childCoordinators: [CoordinatorProtocol] = []
    
    weak var parentCoordinator: CoordinatorProtocol!
    weak var navigationController: UINavigationController!
    weak var tabBarController: UITabBarController!
    
    override init() {
        super.init()
        Logger.initialization(entity: self)
    }
    
    deinit {
        Logger.deinitialization(entity: self)
    }
    
    func start() { }
    func end() { }
    
}

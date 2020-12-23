//
//  AuthCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 22.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class AuthCoordinator: Coordinatable {
    
    weak var parentCoordinator: Coordinatable?
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinatable] = []
    
    private let title: String
    
    init(navigation: UINavigationController,
         title: String
    ) {
        navigationController = navigation
        self.title = title
    }
    
    func start() {
        
    }
    
    func end() {
        
    }
    
}

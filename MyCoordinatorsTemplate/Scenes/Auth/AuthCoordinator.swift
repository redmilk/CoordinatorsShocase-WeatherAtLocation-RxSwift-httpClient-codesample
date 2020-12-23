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
    
    init(title: String) {
        self.title = title
    }
    
    func start() {
        let storyboard = UIStoryboard(name: Storyboard.auth.rawValue, bundle: nil)
        let navigation = storyboard.instantiateInitialViewController() as! UINavigationController
        navigationController = navigation
        let controller = navigation.viewControllers.first as! AuthViewController
        
    }
    
    func end() {
        
    }
    
}

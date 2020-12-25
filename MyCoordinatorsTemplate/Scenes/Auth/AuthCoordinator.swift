//
//  AuthCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 22.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol AuthCoordinatorDelegate: class {
    func didAuthenticate(_ coordinator: AuthCoordinator)
}

class AuthCoordinator: Coordinatable {
    
    weak var delegate: AuthCoordinatorDelegate!
    
    weak var parentCoordinator: Coordinatable!
    weak var navigationController: UINavigationController!
    var childCoordinators: [Coordinatable] = []
    var window: UIWindow
    
    private let title: String
    
    init(title: String,
         window: UIWindow,
         parent: Coordinatable,
         delegate: AuthCoordinatorDelegate) {
        self.title = title
        self.window = window
        self.delegate = delegate
        parentCoordinator = parent
        
        Logger.initialization(entity: self)
    }
    
    deinit {
        Logger.deinitialization(entity: self)
    }
    
    func start() {
        let storyboard = UIStoryboard(name: Storyboard.auth.rawValue, bundle: nil)
        let navigation = storyboard.instantiateInitialViewController() as! UINavigationController
        navigationController = navigation
        let controller = navigation.viewControllers.first as! AuthViewController
        controller.coordinator = self
        controller.title = title
        window.rootViewController = navigation
    }
    
    func end() {
        parentCoordinator.removeChild(self)
        delegate.didAuthenticate(self)
    }
    
}

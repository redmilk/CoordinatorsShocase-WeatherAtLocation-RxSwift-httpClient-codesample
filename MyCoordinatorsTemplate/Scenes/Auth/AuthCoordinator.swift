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

class AuthCoordinator: Coordinator {
    
    weak var delegate: AuthCoordinatorDelegate!
    var window: UIWindow
    
    private let title: String
    
    init(title: String,
         window: UIWindow,
         parent: CoordinatorProtocol,
         delegate: AuthCoordinatorDelegate
    ) {
        self.title = title
        self.window = window
        self.delegate = delegate
        super.init()
        parentCoordinator = parent
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: Storyboard.auth.rawValue, bundle: nil)
        let navigation = storyboard.instantiateInitialViewController() as! UINavigationController
        navigationController = navigation
        let controller = navigation.viewControllers.first as! AuthViewController
        controller.coordinator = self
        controller.title = title
        window.rootViewController = navigation
    }
    
    override func end() {
        parentCoordinator.removeChild(self)
        delegate.didAuthenticate(self)
    }
    
}

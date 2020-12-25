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

final class AuthCoordinator: BaseCoordinator {
    
    weak var delegate: AuthCoordinatorDelegate!
    
    private let title: String
    
    init(title: String,
         window: UIWindow,
         parentCoordinator: CoordinatorProtocol,
         delegate: AuthCoordinatorDelegate
    ) {
        self.title = title
        self.delegate = delegate
        super.init()
        self.window = window
        self.parentCoordinator = parentCoordinator
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: Storyboard.auth.rawValue, bundle: nil)
        navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let controller = navigationController!.viewControllers.first as! AuthViewController
        controller.coordinator = self
        controller.title = title
        window.rootViewController = navigationController
        super.start()
    }
    
    override func end() {
        parentCoordinator.removeChild(self)
        delegate.didAuthenticate(self)
    }
    
}

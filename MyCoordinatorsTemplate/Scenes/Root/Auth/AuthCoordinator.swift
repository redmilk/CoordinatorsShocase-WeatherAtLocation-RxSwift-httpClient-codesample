//
//  AuthCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 22.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol AuthCoordinatorProtocol {
    func dismiss()
}

protocol AuthCoordinatorDelegate: class {
    func didAuthenticate(_ coordinator: AuthCoordinator)
}

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorProtocol {
    
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
        let viewModel = AuthViewModel(coordinator: self, vcTitle: "Authentication")
        let controller = AuthViewController.instantiate(storyboard: .auth,
                                                                  instantiation: .initial) {
           return AuthViewController(viewModel: viewModel, coder: $0)!
        }
        navigationController = UINavigationController.makeStyled(style: .black, root: controller)
        controller.title = title
        window.rootViewController = navigationController
        assignNavigationDelegates()
    }
    
    override func end() {
        parentCoordinator.removeChild(self)
        delegate.didAuthenticate(self)
    }
    
    func dismiss() {
        end()
    }
    
}

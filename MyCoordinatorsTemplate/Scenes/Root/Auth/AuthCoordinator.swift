//
//  AuthCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 22.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol AuthCoordinatorProtocol {
    func displayFinalStepScene(user: User)
    func displayLastNameScene(user: User)
    func end()
}

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorProtocol {
        
    private let title: String
    private var presentationMode: PresentationMode
    
    init(title: String,
         presentationMode: PresentationMode,
         parentCoordinator: CoordinatorProtocol?
    ) {
        self.title = title
        self.presentationMode = presentationMode
        super.init()
        self.window = window
        self.parentCoordinator = parentCoordinator
    }
    
    override func start() {
        switch presentationMode {
        case .root(let window):
            self.window = window
            let viewModel = FirstNameViewModel(vcTitle: "Your first name", coordinator: self)
            let controller = FirstNameViewController.instantiate(storyboard: .auth,
                                                                 instantiation: .withIdentifier,
                                                                 creator: {
                FirstNameViewController(viewModel: viewModel, coder: $0)!
            })
            navigationController = UINavigationController.makeStyled(style: .black, root: controller)
            self.window.rootViewController = navigationController
        case .push(let navigation):
            navigationController = navigation
            currentController = navigation
            let viewModel = FirstNameViewModel(vcTitle: "Your first name", coordinator: self)
            let controller = FirstNameViewController.instantiate(storyboard: .auth,
                                                                 instantiation: .withIdentifier,
                                                                 creator: {
                FirstNameViewController(viewModel: viewModel, coder: $0)!
            })
            navigation.pushViewController(controller, animated: true)
        case .modal(let parentVC):
            let viewModel = FirstNameViewModel(vcTitle: "Your first name", coordinator: self)
            let controller = FirstNameViewController.instantiate(storyboard: .auth,
                                                                 instantiation: .withIdentifier,
                                                                 creator: {
                FirstNameViewController(viewModel: viewModel, coder: $0)!
            })
            navigationController = UINavigationController.makeStyled(style: .black, root: controller)
            currentController = navigationController
            parentVC.present(navigationController!, animated: true, completion: nil)
        }
    }
    
    override func didNavigate(_ navigationController: UINavigationController, to viewController: UIViewController, animated: Bool) {
        super.didNavigate(navigationController, to: viewController, animated: animated)
        if let _ = viewController as? ProfileViewController {
            /// handling of going back with iOS default back button
            parentCoordinator?.removeChild(self)
        }
    }
    
    func displayLastNameScene(user: User) {
        guard let navigationController = navigationController else { fatalError("Internal inconsistency") }
        let viewModel = LastNameViewModel(vcTitle: "Your last name", user: user, coordinator: self)
        let controller = LastNameViewController.instantiate(storyboard: .auth,
                                                            instantiation: .withIdentifier,
                                                            creator: {
            LastNameViewController(viewModel: viewModel, coder: $0)!
        })
        navigationController.pushViewController(controller, animated: true)
    }
    
    func displayFinalStepScene(user: User) {
        guard let navigationController = navigationController else { fatalError("Internal inconsistency") }
        let viewModel = AuthViewModel(coordinator: self,
                                      vcTitle: title,
                                      user: user)
        let controller = AuthViewController.instantiate(storyboard: .auth,
                                                        instantiation: .withIdentifier) {
            return AuthViewController(viewModel: viewModel, coder: $0)!
        }
        navigationController.pushViewController(controller, animated: true)
    }
    
    override func end() {
        super.end()
    }
    
}

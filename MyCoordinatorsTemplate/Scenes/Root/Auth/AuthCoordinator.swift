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
    func authFlowDidFinish(_ coordinator: AuthCoordinator)
}

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorProtocol {
    
    weak var delegate: AuthCoordinatorDelegate?
    
    private let title: String
    private let presentationMode: PresentationMode
    
    init(title: String,
         presentationMode: PresentationMode,
         parentCoordinator: CoordinatorProtocol,
         delegate: AuthCoordinatorDelegate? = nil
    ) {
        self.title = title
        self.delegate = delegate
        self.presentationMode = presentationMode
        super.init()
        self.window = window
        self.parentCoordinator = parentCoordinator
    }
    
    override func start() {
        switch presentationMode {
        case .root(let window):
            let viewModel = AuthViewModel(coordinator: self, vcTitle: title)
            let controller = AuthViewController.instantiate(storyboard: .auth,
                                                            instantiation: .initial) {
                return AuthViewController(viewModel: viewModel, coder: $0)!
            }
            navigationController = UINavigationController.makeStyled(style: .black, root: controller)
            controller.title = title
            window.rootViewController = navigationController
        case .push(let navigation):
            navigationController = navigation
            let viewModel = AuthViewModel(coordinator: self, vcTitle: title)
            let controller = AuthViewController.instantiate(storyboard: .auth,
                                                            instantiation: .initial) {
                return AuthViewController(viewModel: viewModel, coder: $0)!
            }
            controller.title = title
            navigation.pushViewController(controller, animated: true)
        case .modal(let parentVC):
            let viewModel = AuthViewModel(coordinator: self, vcTitle: title)
            let controller = AuthViewController.instantiate(storyboard: .auth,
                                                            instantiation: .initial) {
                return AuthViewController(viewModel: viewModel, coder: $0)!
            }
            currentController = controller
            controller.title = title
            parentVC.present(controller, animated: true, completion: nil)
        }
    }
    
    override func didNavigate(_ navigationController: UINavigationController, to viewController: UIViewController, animated: Bool) {
        super.didNavigate(navigationController, to: viewController, animated: animated)
        if let _ = viewController as? ProfileViewController {
            /// handling of going back with iOS default back button
            parentCoordinator.removeChild(self)
        }
    }
    
    override func end() {
        parentCoordinator.removeChild(self)
        
        switch presentationMode {
        case .root:
            if delegate == nil {
                print("NIL")
            }
            delegate?.authFlowDidFinish(self)
        case .push:
            navigationController?.popViewController(animated: true)
        case .modal:
            currentController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func dismiss() {
        end()
    }
    
}

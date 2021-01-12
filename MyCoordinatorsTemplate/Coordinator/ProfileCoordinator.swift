//
//  ProfileCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 22.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol ProfileCoordinatorProtocol {
    func pushPersonalInfo()
    func presentCreditCards()
    func pushAuth()
    func presentAuth()
    func rootAuth()
    func end()
}

final class ProfileCoordinator: Coordinator, ProfileCoordinatorProtocol {
    
    private let title: String
    private let presentationMode: PresentationMode
    
    init(parentCoordinator: HomeCoordinator,
         title: String,
         presentationType: PresentationMode
    ) {
        self.title = title
        self.presentationMode = presentationType
        super.init()
        self.parentCoordinator = parentCoordinator
        self.navigationController = parentCoordinator.navigationController
    }
    
    override func start() {
        switch presentationMode {
        
        case .push:
            let viewModel = ProfileViewModel(coordinator: self, vcTitle: "Profile")
            let controller = ProfileViewController.instantiate(storyboard: .profile,
                                                               instantiation: .withIdentifier) {
                return ProfileViewController(viewModel: viewModel, coder: $0)!
            }
            navigationController?.pushViewController(controller, animated: true)
            
        case .modal(let parentVC):
            let viewModel = ProfileViewModel(coordinator: self, vcTitle: "Profile")
            let controller = ProfileViewController.instantiate(storyboard: .profile,
                                                               instantiation: .withIdentifier) {
                return ProfileViewController(viewModel: viewModel, coder: $0)!
            }
            let navigation = StyledNavigationControllerFactory.makeStyled(style: .profile, root: controller)
            navigationController = navigation
            currentController = controller
            parentVC.present(navigation, animated: true, completion: nil)
            
        case _: return
        }
    }
    
    /// finish our current coordinator when user taps default back button
    override func didNavigate(_ navigationController: UINavigationController,
                              to viewController: UIViewController,
                              animated: Bool
    ) {
        super.didNavigate(navigationController, to: viewController, animated: animated)
        if let _ = viewController as? HomeViewController {
            end()
        }
    }
    
    func pushPersonalInfo() {
        let viewModel = PersonalInfoViewModel(coordinator: self, vcTitle: "Personal Information")
        let controller = PersonalInfoViewController.instantiate(storyboard: .profile, instantiation: .withIdentifier) {
            return PersonalInfoViewController(viewModel: viewModel, coder: $0)!
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func presentCreditCards() {
        let controller = CreditCardsViewController.instantiate(storyboard: .profile, instantiation: .withIdentifier) {
            return CreditCardsViewController(coder: $0)!
        }
        controller.title = "Credit Cards"
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func pushAuth() {
        guard let navigationController = navigationController else { fatalError("Inconsistency") }
        let child = AuthCoordinator(title: "Authentication",
                                    presentationMode: .push(navigationController),
                                    parentCoordinator: self)
        addChild(child)
        child.start()
    }
    
    func presentAuth() {
        guard let navigationController = navigationController else { fatalError("Inconsistency") }
        let child = AuthCoordinator(title: "Authentication",
                                    presentationMode: .modal(navigationController),
                                    parentCoordinator: self)
        addChild(child)
        child.start()
    }
    
    func rootAuth() {
        end()
    }
    
}

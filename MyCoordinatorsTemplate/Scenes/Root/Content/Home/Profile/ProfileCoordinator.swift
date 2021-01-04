//
//  ProfileCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 22.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol ProfileCoordinatorProtocol {
    func presentPersonalInfo()
    func pushCreditCards()
    func end()
}

final class ProfileCoordinator: BaseCoordinator, ProfileCoordinatorProtocol {
    
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
            
        case .modal:
            let viewModel = ProfileViewModel(coordinator: self, vcTitle: "Profile")
            let controller = ProfileViewController.instantiate(storyboard: .profile,
                                                               instantiation: .withIdentifier) {
                return ProfileViewController(viewModel: viewModel, coder: $0)!
            }
            let navigation = UINavigationController.makeStyled(style: .profile, root: controller)
            navigationController = navigation
            guard
                let parentController = parentCoordinator?.navigationController?.viewControllers.last
            else { fatalError("Internal inconsistency") }
            
            parentController.present(navigation, animated: true, completion: nil)
        }
    }
    
    override func end() {
        switch presentationMode {
        case .modal:
            navigationController?.dismiss(animated: true, completion: nil)
            self.parentCoordinator.removeChild(self)
        case .push:
            navigationController?.popViewController(animated: true)
            parentCoordinator.removeChild(self)
        }
    }
    
    override func didNavigate(_ navigationController: UINavigationController,
                              to viewController: UIViewController,
                              animated: Bool
    ) {
        super.didNavigate(navigationController, to: viewController, animated: animated)
        if let _ = viewController as? HomeViewController {
            end()
        }
    }
    
    func presentPersonalInfo() {
        let controller = PersonalInfoViewController.instantiate(storyboard: .profile, instantiation: .withIdentifier) {
            return PersonalInfoViewController(coder: $0)!
        }
        controller.title = "Personal Information"
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func pushCreditCards() {
        let controller = CreditCardsViewController.instantiate(storyboard: .profile, instantiation: .withIdentifier) {
            return CreditCardsViewController(coder: $0)!
        }
        controller.title = "Credit Cards"
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

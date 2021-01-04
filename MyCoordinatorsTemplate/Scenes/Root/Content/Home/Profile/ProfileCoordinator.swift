//
//  ProfileCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 22.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol ProfileCoordinatorProtocol {
    func displayCreditCardsModally()
    func end()
}

final class ProfileCoordinator: BaseCoordinator, ProfileCoordinatorProtocol {
    
    private let title: String
    private let presentationType: PresentationType
    
    init(parentCoordinator: HomeCoordinator,
         title: String,
         presentationType: PresentationType
    ) {
        self.title = title
        self.presentationType = presentationType
        super.init()
        self.parentCoordinator = parentCoordinator
    }
    
    override func start() {
        switch presentationType {
        
        case .push(let navigation):
            navigationController = navigation
            let viewModel = ProfileViewModel(coordinator: self, vcTitle: "Profile")
            let controller = ProfileViewController.instantiate(storyboard: .profile,
                                                               instantiation: .withIdentifier) {
                return ProfileViewController(viewModel: viewModel, coder: $0)!
            }
            navigation.pushViewController(controller, animated: true)
            
        case .modal:
            let viewModel = ProfileViewModel(coordinator: self, vcTitle: "Profile")
            let controller = ProfileViewController.instantiate(storyboard: .profile,
                                                               instantiation: .withIdentifier) {
                return ProfileViewController(viewModel: viewModel, coder: $0)!
            }
            let navigation = UINavigationController.makeStyled(style: .profile, root: controller)
            navigationController = navigation
            assignNavigationDelegates()
            
            guard
                let parentController = parentCoordinator?.navigationController?.viewControllers.last
            else { fatalError("Internal inconsistency") }
            
            parentController.present(navigation, animated: true, completion: nil)
        }
        
        assignNavigationDelegates()
    }
    
    override func end() {
        switch presentationType {
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
    
    func displayCreditCardsModally() {
        //        let controller = CreditCardsViewController.instantiate(storyboardName: .profile)
        //        controller.title = "Credit Cards"
        //        navigationController?.present(controller, animated: true, completion: nil)
    }
    
}

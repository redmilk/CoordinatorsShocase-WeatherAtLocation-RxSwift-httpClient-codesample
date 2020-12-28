//
//  ProfileCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 22.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class ProfileCoordinator: BaseCoordinator {
    
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
            let controller = ProfileViewController.instantiate(storyboardName: .profile)
            controller.coordinator = self
            navigation.pushViewController(controller, animated: true)
            
        case .modal:
            let storyboard = UIStoryboard(name: Storyboard.profile.rawValue, bundle: nil)
            let navigation = storyboard.instantiateInitialViewController() as! UINavigationController
            navigationController = navigation
            assignNavigationDelegates()
            
            guard
                let parentController = parentCoordinator?.navigationController?.viewControllers.last,
                let profileController = navigation.viewControllers.first as? ProfileViewController
                else { fatalError("Internal inconsistency") }
            
            profileController.coordinator = self
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
    
}

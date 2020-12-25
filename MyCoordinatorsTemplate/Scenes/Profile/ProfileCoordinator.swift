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
            navigationController?.delegate = self
            let controller = ProfileViewController.instantiate(storyboardName: .profile)
            controller.coordinator = self
            navigationController?.pushViewController(controller, animated: true)
        case .modal:
            let storyboard = UIStoryboard(name: Storyboard.profile.rawValue, bundle: nil)
            let navigation = storyboard.instantiateInitialViewController() as! UINavigationController
            navigationController = navigation
            guard
                let parentController = parentCoordinator?.navigationController?.viewControllers.last,
                let profileController = navigation.viewControllers.first as? ProfileViewController
                else { fatalError("Internal inconsistency") }
            
            profileController.coordinator = self
            parentController.present(navigation, animated: true, completion: nil)
        }
    }
    
    override func end() {
        switch presentationType {
        case .modal:
            navigationController?.dismiss(animated: true, completion: {
                self.parentCoordinator.removeChild(self)
            })
        case .push:
            navigationController?.popViewController(animated: true)
            parentCoordinator.removeChild(self)
        }
    }
    
}

extension ProfileCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool
    ) {
        if let _ = viewController as? HomeViewController {
            end()
        }
    }
}

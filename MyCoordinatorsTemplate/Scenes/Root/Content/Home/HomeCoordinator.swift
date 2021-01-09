//
//  HomeCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol HomeCoordinatorProtocol {
    func pushProfile()
    func presentProfile()
}

final class HomeCoordinator: BaseCoordinator, HomeCoordinatorProtocol {
        
    private let title: String
    private var onEnd: () -> Void
    
    init(tabBarController: UITabBarController,
         parentCoordinator: CoordinatorProtocol,
         title: String,
         onEnd: @escaping () -> Void
    ) {
        self.title = title
        self.onEnd = onEnd
        super.init()
        self.tabBarController = tabBarController
        self.parentCoordinator = parentCoordinator
    }
    
    override func start() {
        let homeViewModel = HomeViewModel(coordinator: self)
        let homeVewController = HomeViewController.instantiate(storyboard: .home, instantiation: .initial) {
            return  HomeViewController(title: "Home", viewModel: homeViewModel, coder: $0)!
        }
        let navigationController = UINavigationController.makeStyled(style: .blue, root: homeVewController)
        
        guard
            let tabBarController = tabBarController
            else { fatalError("internal inconsistency") }
        
        tabBarController.addControllerForTab(navigationController)
        self.navigationController = navigationController
    }
    
    override func end() {
        self.onEnd()
        super.end()
    }
    
    // MARK: - Display profile scene
    func pushProfile() {
        let child = ProfileCoordinator(parentCoordinator: self,
                                       title: "Profile",
                                       presentationType: .push(navigationController!),
                                       onEnd: { [weak self] in
                                        self?.end()
                                       })
        addChild(child)
        child.start()
    }
    
    func presentProfile() {
        let child = ProfileCoordinator(parentCoordinator: self,
                                       title: "Profile",
                                       presentationType: .modal(navigationController!),
                                       onEnd: { [weak self] in
                                        self?.end()
                                       })
        addChild(child)
        child.start()
    }
    
}

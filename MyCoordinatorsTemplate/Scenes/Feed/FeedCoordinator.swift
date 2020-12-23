//
//  FeedCoordinator.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class FeedCoordinator: Coordinatable {
    
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinatable] = []
    
    private let title: String
    
    init(navigation: UINavigationController,
         title: String
    ) {
        navigationController = navigation
        self.title = title
    }
    
    func start() {
        let controller = FeedViewController.instantiate(.feed)
        controller.title = title
        navigationController?.tabBarItem = UITabBarItem(title: title, image: nil, selectedImage: nil)
        navigationController?.pushViewController(controller, animated: false)
    }
    
    func end() {
        
    }
    
}

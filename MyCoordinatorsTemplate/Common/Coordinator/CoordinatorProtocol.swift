//
//  Coordinated.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    
    /// if current coordinator has parent
    var parentCoordinator: CoordinatorProtocol? { get set }
    
    /// if navigation starts from UINavigationController
    var navigationController: UINavigationController? { get set }
    
    /// if navigation starts from UITabBarController
    var tabBarController: UITabBarController? { get set }
    
    /// if coordinator can set root scene for application
    var window: UIWindow! { get set }
    
    /// for scene modal presentation and for other conveniences
    var currentController: UIViewController? { get set }
    
    func addChild(_ child: CoordinatorProtocol)
    func removeChild(_ child: CoordinatorProtocol)
    func removeAllChildCoordinators()
        
    func start()
    func end()

}

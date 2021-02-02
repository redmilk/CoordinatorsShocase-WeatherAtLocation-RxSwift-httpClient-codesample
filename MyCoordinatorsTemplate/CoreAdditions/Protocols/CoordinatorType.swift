//
//  Coordinated.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol CoordinatorType: AnyObject {
    
    /// if current coordinator has parent
    var parentCoordinator: CoordinatorType? { get set }
    
    /// if navigation starts from UINavigationController
    var navigationController: UINavigationController? { get set }
    
    /// if navigation starts from UITabBarController
    var tabBarController: UITabBarController? { get set }
    
    /// if coordinator can set root scene for application
    var window: UIWindow! { get set }
    
    /// for scene modal presentation and for other conveniences
    var currentController: UIViewController? { get set }
        
    func addChild(_ child: CoordinatorType)
    func removeChild(_ child: CoordinatorType)
    func clear()
        
    func start()
    func end()

}

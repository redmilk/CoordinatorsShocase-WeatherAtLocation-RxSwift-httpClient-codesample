//
//  UITabBarController+Extensions.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 26.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

extension UITabBarController {
    func addControllerForTab(_ viewController: UIViewController) {
        (viewControllers == nil) ? viewControllers = [viewController]
            : viewControllers?.append(viewController)
    }
}

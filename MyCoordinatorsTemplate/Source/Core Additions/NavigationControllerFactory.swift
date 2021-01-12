//
//  StyledNavigationControllerFactory.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 11.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

struct NavigationControllerFactory {
    
    /// application nav style
    enum Style {
        case home
        case auth
        case feed
        case profile
    }
    
    /// factory func
    static func makeStyled(style: Style,
                           root: UIViewController? = nil
    ) -> UINavigationController {
        func createStyledNavigation(rootVC: UIViewController?,
                                    barTint: UIColor,
                                    fontTint: UIColor,
                                    titleTint: UIColor
        ) -> UINavigationController {
            let navigationController = (rootVC != nil) ? UINavigationController(rootViewController: rootVC!) : UINavigationController()
            navigationController.navigationBar.barTintColor = barTint
            navigationController.navigationBar.tintColor = fontTint
            let textAttributes = [NSAttributedString.Key.foregroundColor: titleTint]
            navigationController.navigationBar.titleTextAttributes = textAttributes
            return navigationController
        }
        
        switch style {
        case .home:
            return createStyledNavigation(rootVC: root, barTint: #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), fontTint: .white, titleTint: .white)
        case .auth:
            return createStyledNavigation(rootVC: root, barTint: #colorLiteral(red: 0.4410825372, green: 1, blue: 0.5693550706, alpha: 1), fontTint: .black, titleTint: .black)
        case .profile:
            return createStyledNavigation(rootVC: root, barTint: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), fontTint: .white, titleTint: .white)
        case .feed:
            return createStyledNavigation(rootVC: root, barTint: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), fontTint: .white, titleTint: .white)
        }
    }
    
    private init() { }
}

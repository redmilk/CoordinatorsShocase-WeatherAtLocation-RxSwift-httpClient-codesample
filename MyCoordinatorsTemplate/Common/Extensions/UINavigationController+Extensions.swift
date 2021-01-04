//
//  UINavigationController+Extensions.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 03.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// TODO: Move domain logic from extensions to helpers
extension UINavigationController {
    
    /// application nav style
    enum Style {
        case blue
        case black
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
        case .blue:
            return createStyledNavigation(rootVC: root, barTint: .blue, fontTint: .white, titleTint: .white)
        case .black:
            return createStyledNavigation(rootVC: root, barTint: .black, fontTint: .white, titleTint: .lightGray)
        case .profile:
            return createStyledNavigation(rootVC: root, barTint: .cyan, fontTint: .black, titleTint: .black)
        case .feed:
            return createStyledNavigation(rootVC: root, barTint: .magenta, fontTint: .white, titleTint: .lightGray)
        }
    }
    
    
}


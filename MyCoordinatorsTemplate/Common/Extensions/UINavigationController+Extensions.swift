//
//  UINavigationController+Extensions.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 03.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    enum Style {
        case blue
        case black
    }
    
    static func styledNavigation(_ rootVC: UIViewController? = nil,
                                 style: Style
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
            return createStyledNavigation(rootVC: rootVC, barTint: .blue, fontTint: .white, titleTint: .white)
        case .black:
            return createStyledNavigation(rootVC: rootVC, barTint: .black, fontTint: .white, titleTint: .lightGray)
        }
        
    }

}


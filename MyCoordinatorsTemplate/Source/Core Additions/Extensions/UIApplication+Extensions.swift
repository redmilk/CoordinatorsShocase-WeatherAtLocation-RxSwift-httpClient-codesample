//
//  UIApplication+Extensions.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 05.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

extension UIApplication {
    
    /// I know this is bad, and it won't work with ipad multiple windowed case
    /// just for simplicity, and excluding window field in coordinator initializers
    static var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                  let window = sceneDelegate.window else { return nil }
            return window
        } else {
            guard let window = UIApplication.shared.windows.first else { return nil}
            return window
        }
    }
    
}

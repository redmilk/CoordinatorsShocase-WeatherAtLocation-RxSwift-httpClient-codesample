//
//  UIViewController+Extensions.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 09.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var calculatedContentHeight: CGFloat {
        let viewHeight = view?.bounds.height ?? 0
        let tabBarHeight = tabBarController?.tabBar.bounds.height ?? 0
        let navigationBarHeight = navigationController?.navigationBar.bounds.height ?? 0
        let bottomInsetHeight = UIApplication.currentWindow?.safeAreaInsets.bottom ?? 0
        let topInsetHeight = UIApplication.currentWindow?.safeAreaInsets.top ?? 0
        return viewHeight - navigationBarHeight - bottomInsetHeight - tabBarHeight - topInsetHeight
    }
    
}

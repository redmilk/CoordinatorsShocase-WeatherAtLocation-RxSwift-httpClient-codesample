//
//  Storyboarded.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// Protocol for controllers that will be presented modally
/// and don't require UINavigationController or UITabBarController

protocol Storyboarded {
    static func instantiate(storyboardName: Storyboard) -> Self
}

extension Storyboarded where Self: UIViewController {

  static func instantiate(storyboardName: Storyboard) -> Self {
    let id = String(describing: self)
    let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: Bundle.main)
    return storyboard.instantiateViewController(withIdentifier: id) as! Self
  }
  
}

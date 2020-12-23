//
//  Storyboarded.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//


import UIKit

enum Storyboard: String {
    case root = "Root"
    case auth = "Auth"
    case content = "Content"
    case home = "Home"
    case feed = "Feed"
    case profile = "Profile"
}


protocol Storyboarded {
    static func instantiate(_ storyboard: Storyboard) -> Self
}


extension Storyboarded where Self: UIViewController {

  static func instantiate(_ storyboard: Storyboard) -> Self {
    let id = String(describing: self)
    let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
    return storyboard.instantiateViewController(withIdentifier: id) as! Self
  }
  
}

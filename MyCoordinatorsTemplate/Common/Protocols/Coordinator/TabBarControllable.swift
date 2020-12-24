//
//  TabBarControllable.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 24.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol TabBarControllable where Self: CoordinatorProtocol {
    var tabBar: UITabBarController! { get set }
}

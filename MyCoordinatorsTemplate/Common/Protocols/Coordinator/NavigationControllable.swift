//
//  HasNavigation.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 23.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

protocol NavigationControllable where Self: CoordinatorProtocol {
    var navigationController: UINavigationController! { get set }
}

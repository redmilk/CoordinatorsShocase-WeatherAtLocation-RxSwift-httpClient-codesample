//
//  HasWindow.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 23.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// Rootable coordinator
protocol Rootable where Self: CoordinatorProtocol {
    var window: UIWindow { get set }
}

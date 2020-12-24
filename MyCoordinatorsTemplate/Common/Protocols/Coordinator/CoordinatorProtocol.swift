//
//  Coordinated.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

/// Coordinator protocols are separated for constructing each scene coordinator individually
/// this is done to prevent implementation of uneeded protocol members
/// and conforms to SOLID - I, Interface segregation principle

protocol CoordinatorProtocol: AnyObject {
    func start()
}

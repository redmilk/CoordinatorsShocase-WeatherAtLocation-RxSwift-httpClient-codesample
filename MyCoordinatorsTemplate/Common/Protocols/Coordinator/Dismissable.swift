//
//  Dismissable.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 23.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol Dismissable where Self: CoordinatorProtocol {
    func end()
}

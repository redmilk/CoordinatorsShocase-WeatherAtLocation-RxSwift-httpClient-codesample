//
//  RequestHeaderAdaptable.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 13.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol URLRequestAdaptable {
    func adapt(_ urlRequest: inout URLRequest)
}

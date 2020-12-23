//
//  Coordinated.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

enum PresentationType {
    case push(UINavigationController)
    case modal
}

protocol Coordinatable: AnyObject {
        
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [Coordinatable] { get set }
    
    func start()
    func end()
    
}

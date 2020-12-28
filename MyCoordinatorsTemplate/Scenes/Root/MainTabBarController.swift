//
//  MainTabBarController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit


final class MainTabBarController: UITabBarController {
    
    var coordinator: TabBarContentCoordinator!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Logger.initialization(entity: self)
    }
    
    deinit {
        Logger.deinitialization(entity: self)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }

}

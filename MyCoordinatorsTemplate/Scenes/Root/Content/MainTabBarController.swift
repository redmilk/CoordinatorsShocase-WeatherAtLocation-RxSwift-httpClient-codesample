//
//  MainTabBarController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit


final class MainTabBarController: UITabBarController {
    
    private let viewModel: MainTabBarViewModel
    
    init?(viewModel: MainTabBarViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    deinit {
        Logger.deinitialization(entity: self)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }

}

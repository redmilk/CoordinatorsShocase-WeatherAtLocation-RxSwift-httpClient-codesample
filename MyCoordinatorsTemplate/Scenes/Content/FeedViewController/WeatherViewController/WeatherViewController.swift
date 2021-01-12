//
//  DetailViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 26.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class WeatherViewController: ViewController, Instantiatable {
        
    let viewModel: WeatherViewModel
    
    required init?(viewModel: WeatherViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
        title = viewModel.vcTitle
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

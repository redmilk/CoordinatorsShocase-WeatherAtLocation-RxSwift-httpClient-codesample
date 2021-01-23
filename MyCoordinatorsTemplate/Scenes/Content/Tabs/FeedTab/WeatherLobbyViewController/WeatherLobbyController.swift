//
//  FeedViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class WeatherLobbyController: ViewController, Instantiatable {
    
    let viewModel: WeatherLobbyViewModel
    
    required init?(viewModel: WeatherLobbyViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
        title = viewModel.vcTitle
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func pushDetailPressed(_ sender: Any) {
        viewModel.pushWeather()
    }
    
    @IBAction func customControllerPressed(_ sender: Any) {
        viewModel.presentWeather()
    }
}

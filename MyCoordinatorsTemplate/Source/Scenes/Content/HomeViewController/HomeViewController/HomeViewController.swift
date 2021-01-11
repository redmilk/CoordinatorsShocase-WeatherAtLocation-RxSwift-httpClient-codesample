//
//  HomeViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class HomeViewController: ViewController, Instantiatable {

    private let viewModel: HomeViewModelProtocol
        
    init?(title: String, viewModel: HomeViewModelProtocol, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
        self.title = title
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBarController?.tabBar.items?[0].image = TabBarIcons.home
    }
    
    @IBAction func pushProfilePressed(_ sender: Any) {
        viewModel.pushProfile()
    }
    
    @IBAction func presentProfilePressed(_ sender: Any) {
        viewModel.presentProfile()
    }
    
    @IBAction func rootProfilePressed(_ sender: Any) {
        
    }
    
}

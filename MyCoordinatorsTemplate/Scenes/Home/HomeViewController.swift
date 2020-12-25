//
//  HomeViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController, Storyboarded {

    var coordinator: HomeCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        isLoggedIn = false
        coordinator.displayAuthAsRoot()
    }
    
    @IBAction func pushProfilePressed(_ sender: Any) {
        coordinator?.pushProfile()
    }
    
    @IBAction func presentProfilePressed(_ sender: Any) {
        coordinator?.presentProfile()
    }
    
    @IBAction func presentAuthPressed(_ sender: Any) {
        
    }
    
    @IBAction func presentFormsPressed(_ sender: Any) {
        
    }
    
}

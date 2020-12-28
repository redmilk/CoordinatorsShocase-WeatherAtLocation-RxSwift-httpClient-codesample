//
//  AuthViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class AuthViewController: ViewController {
    
    weak var coordinator: AuthCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loggedInPressed(_ sender: Any) {
        isLoggedIn = true
        coordinator.end()
    }
    
}

//
//  HomeViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {

    var coordinator: (ProfileCoordinatable & AuthCoordinatable)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

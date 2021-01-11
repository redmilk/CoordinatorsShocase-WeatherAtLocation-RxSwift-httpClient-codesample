//
//  ProfileViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController, Storyboarded {

    weak var coordinator: ProfileCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func personalInformationPressed(_ sender: Any) {
        
    }
    
    @IBAction func creditCardsPressed(_ sender: Any) {
        
    }
    
    @IBAction func orderHistoryPressed(_ sender: Any) {
        
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        
    }

    @IBAction func closePressed(_ sender: Any) {
        coordinator?.end()
    }
}

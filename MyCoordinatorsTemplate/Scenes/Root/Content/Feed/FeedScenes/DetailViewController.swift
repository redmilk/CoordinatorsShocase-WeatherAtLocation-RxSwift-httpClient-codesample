//
//  DetailViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 26.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class DetailViewController: ViewController, Storyboarded {
    
    var coordinator: FeedCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if coordinator?.navigationController?.delegate != nil  {
            //Logger.log(entity: coordinator?.navigationController?.delegate)
        } else {
            print("DetailViewController Navigation delegate NIL")
        }
    }

}

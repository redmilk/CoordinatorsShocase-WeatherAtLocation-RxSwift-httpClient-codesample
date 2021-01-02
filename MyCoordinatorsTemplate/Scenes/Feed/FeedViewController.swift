//
//  FeedViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class FeedViewController: ViewController, Storyboarded {

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
            print("FeedViewController Navigation delegate NIL")
        }
    }

    @IBAction func pushDetailPressed(_ sender: Any) {
        coordinator?.displayDetail()
    }
    
    @IBAction func customControllerPressed(_ sender: Any) {
        coordinator.displayDraggable()
    }
    
    @IBAction func presentDraggableProtocolController(_ sender: Any) {
        
    }
}

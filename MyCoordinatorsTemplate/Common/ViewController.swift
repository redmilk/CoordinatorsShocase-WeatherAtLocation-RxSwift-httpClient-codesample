//
//  ViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 28.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

open class ViewController: UIViewController {
        
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        Logger.initialization(entity: self)
    }
    
    deinit {
        Logger.deinitialization(entity: self)
    }
    
}

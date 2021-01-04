//
//  DetailViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 26.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

class DetailViewController: ViewController, Instantiatable {
        
    let viewModel: DetailViewModel
    
    required init?(viewModel: DetailViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if coordinator?.navigationController?.delegate != nil  {
//            //Logger.log(entity: coordinator?.navigationController?.delegate)
//        } else {
//            print("DetailViewController Navigation delegate NIL")
//        }
    }

}

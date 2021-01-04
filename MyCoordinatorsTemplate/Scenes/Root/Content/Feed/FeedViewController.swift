//
//  FeedViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class FeedViewController: ViewController, Instantiatable {
    
    let viewModel: FeedViewModel
    
    required init?(viewModel: FeedViewModel, coder: NSCoder) {
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
//            print("FeedViewController Navigation delegate NIL")
//        }
    }

    @IBAction func pushDetailPressed(_ sender: Any) {
        viewModel.pushDetail()
    }
    
    @IBAction func customControllerPressed(_ sender: Any) {
        viewModel.presentNoStoryboardVC()
    }
    
    @IBAction func presentDraggableProtocolController(_ sender: Any) {
        
    }
}

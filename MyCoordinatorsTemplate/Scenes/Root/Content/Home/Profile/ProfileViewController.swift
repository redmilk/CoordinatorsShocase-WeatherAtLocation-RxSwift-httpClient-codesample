//
//  ProfileViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class ProfileViewController: ViewController, Instantiatable {
    
    let viewModel: ProfileViewModel
    
    init?(viewModel: ProfileViewModel, coder: NSCoder) {
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
//            print("ProfileViewController Navigation delegate NIL")
//        }
    }
    
    @IBAction func personalInformationPressed(_ sender: Any) {
        viewModel.presentPersonalInfo()
    }
    
    @IBAction func creditCardsPressed(_ sender: Any) {
        viewModel.pushCreditCards()
    }
    
    @IBAction func pushAuthPressed(_ sender: Any) {
        viewModel.pushAuth()
    }
    
    @IBAction func presentAuthPressed(_ sender: Any) {
        viewModel.presentAuth()
    }
    
    @IBAction func rootAuthPressed(_ sender: Any) {
        viewModel.rootAuth()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        viewModel.dismiss()
    }
}

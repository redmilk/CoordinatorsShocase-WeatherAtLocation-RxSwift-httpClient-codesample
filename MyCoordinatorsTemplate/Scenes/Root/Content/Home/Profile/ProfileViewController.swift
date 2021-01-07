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

    override func handleDefaultModalDismissing() {
        viewModel.dismiss()
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
        
    @IBAction func logOutPressed(_ sender: Any) {
        viewModel.logOut()
    }
}

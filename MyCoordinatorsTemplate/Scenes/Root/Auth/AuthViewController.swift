//
//  AuthViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class AuthViewController: ViewController, Instantiatable {
    
    let viewModel: AuthViewModelProtocol
    
    required init?(viewModel: AuthViewModelProtocol, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// For iOS modal dragging VC dismiss handling
        if isBeingDismissed {
            viewModel.dismiss()
        }
    }
    
    @IBAction func loggedInPressed(_ sender: Any) {
        if viewModel.performLogIn() {
            viewModel.dismiss()
        }
    }
    
}

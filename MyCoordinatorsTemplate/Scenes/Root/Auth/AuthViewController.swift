//
//  AuthViewController.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 21.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import UIKit

final class AuthViewController: ViewController, Instantiatable, AuthSessionSupporting {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    
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
        userNameLabel.text = authService.user?.fullName
        authService.subscribeToUserChanges { [weak self] (user) in
            guard let user = user else {
                self?.userNameLabel.text = "Not logged in"
                self?.logInButton.isHidden = true
                return
            }
            self?.userNameLabel.text = user.fullName
            self?.logInButton.isHidden = false
        }
    }
 
    override func handleDefaultModalDismissing() {
        viewModel.dismiss()
    }
    
    @IBAction func loggedInPressed(_ sender: Any) {
        viewModel.performLogIn { [weak self] (isLoggedIn) in
            self?.viewModel.dismiss()
        }
    }
    
    @IBAction func saveUserPressed(_ sender: Any) {
        viewModel.saveUser()
    }
    
    @IBAction func deleteUserPressed(_ sender: Any) {
        viewModel.deleteUser()
    }
}

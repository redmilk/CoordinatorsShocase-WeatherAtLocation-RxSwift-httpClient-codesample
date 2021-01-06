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
        
        userNameLabel.text = auth.user?.fullName
        
        auth.subscribeToUserChanges { [weak self] (user) in
            guard let user = user else {
                self?.userNameLabel.text = "Not logged in"
                return
            }
            self?.userNameLabel.text = user.fullName
        }
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
    
    @IBAction func saveUserPressed(_ sender: Any) {
        let accessToken = AccessToken(token: "666777888999-TOKEN-111", uid: "190")
        let user = User(accessToken.uid, "Danil", "Timofeev", "timofeev.danil@gmail.com", accessToken)
        auth.setupUser(user)
    }
    
    @IBAction func deleteUserPressed(_ sender: Any) {
        guard let user = auth.user else {
            Logger.log("Not logged in", entity: self, symbol: "❕")
            return
        }
        auth.logout(user: user) { [weak self] in
            guard let self = self else { return }
            guard self.auth.fetchUser() == nil else { fatalError("Internal inconsistency") }
            guard self.auth.user == nil else { fatalError("Internal inconsistency") }
        }
    }
    
    @IBAction func retreiveUserPressed(_ sender: Any) {
        userNameLabel.text = auth.fetchUser()?.fullName
    }
}

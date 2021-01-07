//
//  AuthViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 03.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol AuthViewModelProtocol {
    var title: String { get set }
    func performLogIn(completion: @escaping (Bool) -> Void)
    func saveUser()
    func deleteUser()
    func dismiss()
}

extension AuthViewModel: AuthSessionSupporting { }

struct AuthViewModel: AuthViewModelProtocol {
    
    let coordinator: AuthCoordinatorProtocol
    var title: String
    
    init(coordinator: AuthCoordinatorProtocol,
         vcTitle: String
    ) {
        self.coordinator = coordinator
        self.title = vcTitle
    }
    
    func performLogIn(completion: @escaping (Bool) -> Void) {
        /// Pseudo log in
        let accessToken = AccessToken(token: "666777888999-TOKEN-111", uid: "190")
        let user = User(accessToken.uid, "Danil", "Timofeev", "timofeev.danil@gmail.com", accessToken)
        authService.setupUser(user, onSuccess: {
            self.coordinator.dismiss()
        })
    }
    
    func saveUser() {
        let accessToken = AccessToken(token: "666777888999-TOKEN-111", uid: "190")
        let user = User(accessToken.uid, "Danil", "Timofeev", "timofeev.danil@gmail.com", accessToken)
        authService.setupUser(user, onSuccess: nil)
    }
    
    func deleteUser() {
        guard let user = authService.user else {
            Logger.log("Not logged in", entity: nil, symbol: "❕")
            return
        }
        authService.logout(user: user, completion: nil)
    }
    
    func dismiss() {
        coordinator.dismiss()
    }
    
}

//
//  AuthViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 03.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol AuthViewModelProtocol {
    var user: User { get }
    var title: String { get }
    
    func performLogIn(completion: @escaping () -> Bool)
    func deleteUser()
    func dismissAuthFlow()
}


struct AuthViewModel: AuthViewModelProtocol {
    
    func performLogIn(completion: @escaping () -> Bool) {
        /// Pseudo log in
        let accessToken = AccessToken(token: "666777888999-TOKEN-111", uid: "190")
        user.accessToken = accessToken
        authService.setupUser(user, onSuccess: {
            if completion() {
                self.coordinator.end()
            }
        })
    }
    
    func deleteUser() {
        guard let user = authService.fetchUser() else {
            Logger.log("Not logged in", entity: nil, symbol: "❕")
            return
        }
        authService.logout(user: user, completion: {
            self.coordinator.end()
        })
    }
    
    func dismissAuthFlow() {
        coordinator.end()
    }
        
    init(coordinator: AuthCoordinatorProtocol,
         vcTitle: String,
         authService: AuthSessionProtocol,
         user: User
    ) {
        self.coordinator = coordinator
        self.title = vcTitle
        self.user = user
        self.authService = authService
    }
    
    let user: User
    let coordinator: AuthCoordinatorProtocol
    let title: String
    let authService: AuthSessionProtocol
}

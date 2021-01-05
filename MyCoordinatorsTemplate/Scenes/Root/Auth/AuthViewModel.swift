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
    func performLogIn() -> Bool
    func dismiss()
}

struct AuthViewModel: AuthViewModelProtocol {
    
    let coordinator: AuthCoordinatorProtocol
    var title: String
    
    init(coordinator: AuthCoordinatorProtocol,
         vcTitle: String
    ) {
        self.coordinator = coordinator
        self.title = vcTitle
    }
    
    func performLogIn() -> Bool {
        /// Pseudo log in
        isLoggedIn = true
        return isLoggedIn
    }
    
    func dismiss() {
        coordinator.dismiss()
    }
    
}

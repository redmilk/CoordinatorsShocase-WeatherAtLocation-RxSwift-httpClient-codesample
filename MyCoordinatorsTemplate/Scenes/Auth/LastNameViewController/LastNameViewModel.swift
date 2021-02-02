//
//  LastNameViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 08.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol LastNameViewModelProtocol {
    var vcTitle: String { get } 
    var user: User { get }
    func setLastName(_ lastName: String?)
    func nextStep()
    func dismissAuthFlow()
}

struct LastNameViewModel: LastNameViewModelProtocol {
    
    func setLastName(_ lastName: String?) {
        guard let name = lastName, !name.isEmpty else { return }
        self.user.lastName = lastName
    }
    
    func nextStep() {
        /// pseudo validation
        guard let lastName = user.lastName, lastName.count > 0 else {
            Logger.log("Last name must be at least one character long", entity: nil, symbol: "🚷")
            return
        }
        let accessToken = AccessToken(token: "111-ACCESS-TOKEN-222", uid: "190")
        user.accessToken = accessToken
        coordinator.displayFinalStepScene(user: user)
    }
    
    func dismissAuthFlow() {
        coordinator.end()
    }
        
    init(vcTitle: String, user: User, coordinator: AuthCoordinatorProtocol) {
        self.user = user
        self.coordinator = coordinator
        self.vcTitle = vcTitle
    }
    
    let coordinator: AuthCoordinatorProtocol
    let user: User
    let vcTitle: String
}

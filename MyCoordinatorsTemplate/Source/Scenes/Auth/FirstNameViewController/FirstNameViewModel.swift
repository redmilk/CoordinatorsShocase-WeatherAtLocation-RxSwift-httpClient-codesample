//
//  FirstNameViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 08.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol FirstNameViewModelProtocol {
    var user: User { get }
    var vcTitle: String { get }
    func setFirstName(_ firstName: String?)
    func nextStep()
    func dismissAuthFlow()
}

struct FirstNameViewModel: FirstNameViewModelProtocol {
    
    let user: User
    var coordinator: AuthCoordinatorProtocol
    let vcTitle: String
    
    init(vcTitle: String, coordinator: AuthCoordinatorProtocol) {
        self.coordinator = coordinator
        self.user = User("1", nil, nil, nil, nil)
        self.vcTitle = vcTitle
    }
    
    func setFirstName(_ firstName: String?) {
        guard let name = firstName, !name.isEmpty else { return }
        self.user.firstName = firstName
    }
    
    func nextStep() {
        /// pseudo validation
        guard let firstName = user.firstName, firstName.count > 0 else {
            Logger.log("First name must be at least one character long", entity: nil, symbol: "🚷")
            return
        }
        coordinator.displayLastNameScene(user: user)
    }
    
    func dismissAuthFlow() {
        coordinator.end()
    }
}

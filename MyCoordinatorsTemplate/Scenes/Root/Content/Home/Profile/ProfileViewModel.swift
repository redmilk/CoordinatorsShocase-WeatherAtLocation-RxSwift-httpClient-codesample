//
//  ProfileViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 03.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol ProfileViewModelProtocol {
    var vcTitle: String { get }
    func presentCreditCards()
    func dismiss()
}

struct ProfileViewModel: ProfileViewModelProtocol {
    
    let coordinator: ProfileCoordinatorProtocol
    let vcTitle: String
    
    init(coordinator: ProfileCoordinatorProtocol, vcTitle: String) {
        self.coordinator = coordinator
        self.vcTitle = vcTitle
    }
    
    func presentCreditCards() {
        coordinator.displayCreditCardsModally()
    }
    
    func dismiss() {
        coordinator.end()
    }
}

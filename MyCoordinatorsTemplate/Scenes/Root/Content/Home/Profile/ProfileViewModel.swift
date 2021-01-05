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
    func pushCreditCards()
    func presentPersonalInfo()
    func pushAuth()
    func presentAuth()
    func rootAuth()
    func dismiss()
}

// TODO: - make viewmodel as class, and protocols with weak, constraint them to class
struct ProfileViewModel: ProfileViewModelProtocol {
    
    let coordinator: ProfileCoordinatorProtocol
    let vcTitle: String
    
    init(coordinator: ProfileCoordinatorProtocol, vcTitle: String) {
        self.coordinator = coordinator
        self.vcTitle = vcTitle
    }
    
    func presentPersonalInfo() {
        coordinator.pushPersonalInfo()
    }
    
    func pushCreditCards() {
        coordinator.presentCreditCards()
    }
    
    func pushAuth() {
        coordinator.pushAuth()
    }
    
    func presentAuth() {
        coordinator.presentAuth()
    }
    
    func rootAuth() {
        coordinator.rootAuth()
    }
    
    func dismiss() {
        coordinator.end()
    }
}

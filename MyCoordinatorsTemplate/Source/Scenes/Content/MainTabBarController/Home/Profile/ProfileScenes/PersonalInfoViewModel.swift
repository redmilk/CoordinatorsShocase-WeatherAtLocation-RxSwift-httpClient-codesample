//
//  PersonalInfoViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 09.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol PersonalInfoViewModelProtocol {
    var vcTitle: String { get }
    var fullName: String? { get }
    func dismiss()
}

// MARK: - Capabilities
extension PersonalInfoViewModel: Sessionable { }

struct PersonalInfoViewModel: PersonalInfoViewModelProtocol {
    
    private let coordinator: ProfileCoordinatorProtocol
    
    let vcTitle: String
    
    var fullName: String? {
        return auth.user?.fullName
    }
    
    init(coordinator: ProfileCoordinatorProtocol, vcTitle: String) {
        self.coordinator = coordinator
        self.vcTitle = vcTitle
    }
    
    func dismiss() {
        coordinator.end()
    }
    
}

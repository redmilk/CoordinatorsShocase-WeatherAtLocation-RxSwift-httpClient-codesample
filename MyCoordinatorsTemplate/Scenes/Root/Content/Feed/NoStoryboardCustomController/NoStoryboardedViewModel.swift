//
//  NoStoryboardedViewModel.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 04.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

struct NoStoryboardedViewModel {
    
    let coordinator: FeedCoordinator
    let vcTitle: String
    
    init(coordinator: FeedCoordinator, vcTitle: String) {
        self.coordinator = coordinator
        self.vcTitle = vcTitle
    }
    
}
